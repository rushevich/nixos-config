{ self, inputs, ... }:
{
  flake.nixosModules.mail =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) myNotmuch myMbsync myMsmtp;
    in
    {
      environment.systemPackages = [
        myNotmuch
        myMbsync
        myMsmtp
        pkgs.pass
        pkgs.gnupg
      ];

      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };

      systemd.user.services.mbsync = {
        description = "Mailbox synchronization";
        serviceConfig = {
          Type = "oneshot";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mail/gmail";
          ExecStart = "${myMbsync}/bin/mbsync -a";
          ExecStartPost = "${myNotmuch}/bin/notmuch new";
        };
      };

      systemd.user.timers.mbsync = {
        description = "Periodic mailbox synchronization";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnStartupSec = "2m";
          OnUnitActiveSec = "5m";
          Persistent = true;
        };
      };
    };

  perSystem =
    { pkgs, lib, ... }:
    let
      maildir = "/home/george/mail";

      postNew = pkgs.writeShellScript "notmuch-post-new" ''
        nm=${pkgs.notmuch}/bin/notmuch
        $nm tag +inbox +unread -new -- tag:new and folder:gmail/Inbox
        $nm tag +sent -new -unread -- tag:new and folder:gmail/Sent
        $nm tag +draft -new        -- tag:new and folder:gmail/Drafts
        $nm tag +spam -new         -- tag:new and folder:gmail/Spam
        $nm tag -new               -- tag:new
      '';

      notmuchHooks = pkgs.runCommand "notmuch-hooks" { } ''
        mkdir -p $out
        ln -s ${postNew} $out/post-new
      '';
    in
    {
      packages.myNotmuch = inputs.wrapper-modules.wrappers.notmuch.wrap {
        inherit pkgs;
        settings = {
          database = {
            path = maildir;
            mail_root = maildir;
            hook_dir = "${notmuchHooks}";
          };
          user = {
            name = "George Rushevich";
            primary_email = "george@rushevich.com";
          };
          new = {
            tags = "new";
            ignore = ".mbsyncstate;.uidvalidity;.mbsyncstate.new;.mbsyncstate.journal;.mbsyncstate.lock";
          };
          search.exclude_tags = "deleted;spam";
          maildir.synchronize_flags = true;
        };
      };

      packages.myMbsync = inputs.wrapper-modules.lib.wrapPackage (
        { config, ... }:
        {
          inherit pkgs;
          package = pkgs.isync;
          runtimePkgs = [
            pkgs.pass
            pkgs.gnupg
          ];
          constructFiles.mbsyncrc = {
            relPath = "etc/mbsyncrc";
            content = ''
              IMAPAccount gmail
              Host imap.gmail.com
              Port 993
              User george@rushevich.com
              PassCmd "pass show email/gmail"
              TLSType IMAPS
              CertificateFile /etc/ssl/certs/ca-certificates.crt
              PipelineDepth 50

              IMAPStore gmail-remote
              Account gmail

              MaildirStore gmail-local
              Path ${maildir}/gmail/
              Inbox ${maildir}/gmail/Inbox
              SubFolders Verbatim

              Channel gmail-inbox
              Far :gmail-remote:INBOX
              Near :gmail-local:INBOX
              Create Both
              Expunge Both
              CopyArrivalDate yes
              SyncState *

              Channel gmail-sent
              Far :gmail-remote:"[Gmail]/Sent Mail"
              Near :gmail-local:"Sent"
              Create Both
              Expunge Both
              CopyArrivalDate yes
              SyncState *

              Channel gmail-drafts
              Far :gmail-remote:"[Gmail]/Drafts"
              Near :gmail-local:"Drafts"
              Create Both
              Expunge Both
              CopyArrivalDate yes
              SyncState *

              Channel gmail-trash
              Far :gmail-remote:"[Gmail]/Trash"
              Near :gmail-local:"Trash"
              Create Both
              Expunge Both
              CopyArrivalDate yes
              SyncState *

              Channel gmail-spam
              Far :gmail-remote:"[Gmail]/Spam"
              Near :gmail-local:"Spam"
              Create Both
              Expunge Both
              CopyArrivalDate yes
              SyncState *

              Group gmail
              Channel gmail-inbox
              Channel gmail-sent
              Channel gmail-drafts
              Channel gmail-trash
              Channel gmail-spam
            '';
          };
          flags."-c" = config.constructFiles.mbsyncrc.path;
        }
      );

      packages.myMsmtp = inputs.wrapper-modules.lib.wrapPackage (
        { config, ... }:
        {
          inherit pkgs;
          package = pkgs.msmtp;
          runtimePkgs = [
            pkgs.pass
            pkgs.gnupg
          ];
          constructFiles.msmtprc = {
            relPath = "etc/msmtprc";
            content = ''
              defaults
              auth on
              tls on
              tls_trust_file /etc/ssl/certs/ca-certificates.crt
              logfile ~/.local/state/msmtp.log

              account gmail
              host smtp.gmail.com
              port 587
              from george@rushevich.com
              user george@rushevich.com
              passwordeval "pass show email/gmail"

              account default : gmail
            '';
          };
          flags."-C" = config.constructFiles.msmtprc.path;
        }
      );
    };
}
