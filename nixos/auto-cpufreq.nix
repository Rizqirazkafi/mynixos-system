{ config, libs, pkgs, ... }: {
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
      energy_performance_preference = "power";
      scaling_max_freq = 1200000;
    };
    charger = {
      governor = "performance";
      turbo = "auto";
      energy_performance_preference = "performance";
    };
  };
}
