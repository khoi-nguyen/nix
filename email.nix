{ ... }:

{
  home-manager.users.khoi = {
    accounts.email = {
      accounts = {
        "nguyen.me.uk" = {
          primary = true;
          address = "khoi@nguyen.me.uk";
          realName = "Khôi Nguyễn";
          passwordCommand = "cat ~/.passwords | grep nguyen.me.uk | awk '{ print $2 }'";
          flavor = "gmail.com";
          folders = {
            drafts = "[Gmail]/Drafts";
            sent = "[Gmail]/Sent Mail";
            trash = "[Gmail]/Bin";
          };
          signature = {
            text = ''
              Khôi Nguyễn
            '';
            showSignature = "append";
          };
          msmtp.enable = true;
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          neomutt = {
            enable = true;
            extraConfig = ''
              macro index,pager a "<save-message>=[Gmail]/All<tab><enter><enter>" "Archive"
            '';
          };
        };
      };
    };
    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
      neomutt = {
        enable = true;
        vimKeys = true;
        sidebar.enable = true;
        editor = "nvim";
        extraConfig = builtins.readFile ./neomuttrc;
      };
    };
  };
}
