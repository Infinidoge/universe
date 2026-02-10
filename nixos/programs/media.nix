{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    ghostscript
    graphviz
    imagemagick
    mpv
    pandoc
    yt-dlp
  ];

  environment.shellAliases = {
    acat = "mpv --no-audio-display";
    vcat = "mpv";

    yt-m4a = ''yt-dlp -f "bestaudio[ext=m4a]" -o "%(title)s.%(ext)s"'';
    yt-mp4 = ''yt-dlp -f "best[ext=mp4]" -o "%(title)s.%(ext)s"'';
  };

  environment.interactiveShellInit = ''
    disgetconv() {
      url="$1"
      tmpFileName="''${$(basename "$url")%%\?*}.XXX"
      tmpFile=$(mktemp -t $tmpFileName)
      curl "$url" --output "$tmpFile"
      shift 1
      magick "$tmpFile" "$@"
    }

    disgetconvv() {
      url="$1"
      tmpFileName="''${$(basename "$url")%%\?*}.XXX"
      tmpFile=$(mktemp -t $tmpFileName)
      curl "$url" --output "$tmpFile"
      shift 1
      ffmpeg -i "$tmpFile" "$@"
    }
  '';
}
