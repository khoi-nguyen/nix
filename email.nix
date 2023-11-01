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
          msmtp.enable = true;
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          neomutt.enable = true;
        };
      };
    };
    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
      neomutt = {
        enable = true;
        vimKeys = true;
        editor = "nvim";
        extraConfig = builtins.readFile ./neomuttrc;
      };
    };
  };
}
