{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cnijfilter2
      gutenprintBin
      cupsBjnp
      cups-bjnp
      canon-cups-ufr2
      carps-cups
      cnijfilter_2_80
      cnijfilter_4_00
    ];
  };
}
