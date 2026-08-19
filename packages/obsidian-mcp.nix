{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "obsidian-mcp";
  version = "2.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-N72K8g7B2vbm4yy5KQKK8LjTHQpaw2HzdzQXRcV6M+g=";
  };

  cargoHash = "sha256-DcdVN9P/EyuRt551Kl3kGjz/ZkyFwUQ0GUMo3E3hqqM=";
  cargoDepsName = pname;

  meta = {
    description = "MCP server for Obsidian vaults";
    homepage = "https://github.com/lstpsche/obsidian-mcp";
    license = lib.licenses.mit;
    mainProgram = "obsidian-mcp";
  };
}
