function [lat,long,latcc,longcc] = getGMCgrid()
% generate the GCM grid with top left pixel corner lat 90, long -180
% degrees with 0.05 degree pixel length (~5600m x 5600m)

lat = 90:-0.05:-90;
long = -180: 0.05: 180;

latcc = lat(1:end-1)-0.025;
longcc = long(1:end-1) + 0.025;
