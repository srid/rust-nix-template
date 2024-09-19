{ inputs, ... }:

{
  flake = rec {
    templates.default = {
      description = "A batteries-included Rust project template for Nix";
      path = builtins.path { path = inputs.self; };
    };

    # https://omnix.page/om/init.html#spec
    om.templates.rust-nix-template = {
      template = templates.default;
      params = [
        {
          name = "package-name";
          description = "Name of the Rust package";
          placeholder = "rust-nix-template";
        }
        {
          name = "author";
          description = "Author name";
          placeholder = "Sridhar Ratnakumar";
        }
        {
          name = "author-email";
          description = "Author email";
          placeholder = "srid@srid.ca";
        }
        {
          name = "vscode";
          description = "Include the VSCode settings folder (./.vscode)";
          paths = [ ".vscode" ];
          value = true;
        }
        {
          name = "github-ci";
          description = "Include GitHub Actions workflow configuration";
          paths = [ ".github" ];
          value = true;
        }
        {
          name = "nix-template";
          description = "Keep the flake template in the project";
          paths = [ "**/template.nix" ];
          value = false;
        }
      ];
    };
  };
}
