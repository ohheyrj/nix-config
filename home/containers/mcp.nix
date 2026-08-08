{ ... }:
{
  services.podman.containers = {
    terraform-mcp = {
      autoStart = true;
      image = "hashicorp/terraform-mcp-server";
    };
  };
}