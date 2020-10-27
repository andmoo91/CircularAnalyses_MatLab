close all
%this sets the time for the 24.5 second tracking. Comment out if doing 1
%min tracking.
%Tiempo = linspace(0,24.5,50)'

%This sets the time for the 60 second tracking. Comment out if doing 24.5s
%tracking
Tiempo = linspace(0,60,121)';
%Tiempo = linspace(0,30,61)'
%Tiempo = linspace(0,148,297)'



%loop to break matrix of XY points into Nx2 matrices and add T in front
%Also makes a cell array that is 1xSizeA,2-1. I don't knmow why I called it
%legs but whatever.
for i = 1:2:size(A,2)-1;
    T=i+1;
    B = A(:,i);
    MD = A(:,T);
    Legs{i}=[Tiempo,B,MD];
    zeroedX = A(:,i)-mean(A(:,i));
    zeroedY = A(:,T)-mean(A(:,T));
    ZeroOut{i} = [zeroedX zeroedY];
    %[khull,ahull] = convhull(zeroedX,zeroedY)
    %HullArea{i} = ahull
    %HullPoints{i} = khull  
end


%This is clearing the empty space out of the cell array and inexplicably i
%called it pop
Pop = Legs(:,1:2:end)';
%HullPointsMat = HullPoints(:,1:2:end)'
%HullAreaAll = cell2mat(HullArea(:,1:2:end)')


%this loads my cell array into the tinivez script and plots the tracks,
%computes the MSD, and computes the velocity autocorr
ma = msdanalyzer(2, "um", "s");
ma = ma.addAll(Pop);
disp(ma);
ma = ma.fitMSD;
ma.plotTracks;
figure
ma=ma.computeVCorr;
ma.vcorr;
ma.plotMeanVCorr;
ma = ma.computeMSD;
figure
ma.plotMSD;
figure

TrackV=ma.getVelocities;

cla
ma.plotMeanMSD(gca, true);
[fo, gof] = ma.fitMeanMSD;
plot(fo)
ma.labelPlotMSD;
legend off


% Retrieve instantaneous velocities, per track
 trackV = ma.getVelocities;

 % Pool track data together
 TV = vertcat( trackV{:} );

 % Velocities are returned in a N x (nDim+1) array: [ T Vx Vy ...]. So the
 % velocity vector in 2D is:
 V = TV(:, 2:3);

 % Compute diffusion coefficient
varV = var(V);
mVarV = mean(varV); % Take the mean of the two estimates
Dest = mVarV / 2 * 0.5;


%This is another for loop that just spits out all the MSD and Vcorr stuff
msdLeng = size(A,1);
fitLeng = size(A,1);
vCorrLeng = size(A,1)-1;
Allleng = size(A,2)/2;
msdAll = zeros(msdLeng, Allleng);
vCorrAll = zeros(vCorrLeng,Allleng);
lfitAll = zeros(1,Allleng);
lfitB = zeros(1,Allleng);
Rval = zeros(1,Allleng);

for o = 1:Allleng
  R = ma.msd{o,1}(:,2);
  TP = ma.vcorr{o,1}(:,2);
  JV = ma.lfit.a(o,1);
  JM = ma.lfit.b(o,1);
  JR = ma.lfit.r2fit(o,1);
  msdAll(:,o)=R;
  vCorrAll(:,o) = TP;
  lfitAll(:,o) = JV;
  lfitB(:,o)=JM;
  Rval(:,o)=JR;
end
LinearFitAlpha = [lfitAll' lfitB' Rval'];

Deff = (LinearFitAlpha(:,1)./ 2./ma.n_dim);
Dmean = mean(LinearFitAlpha(:,1)./ 2./ma.n_dim);
Dstd =  std(LinearFitAlpha(:,1)./.2./ma.n_dim);

[velotheta velorho]=cart2pol(V(:,1),V(:,2));
shiftedvelo = velotheta(2:end);
unshiftedvelo = velotheta(1:end-1);
AngleDiff = circ_dist(unshiftedvelo,shiftedvelo);
figure
polarhistogram(AngleDiff,24,"normalization","pdf")
axis([0 360 0 .5])
% 
% 
%% 

%this makes an aligned plot
psst=figure
for bab = 1:2:2
    dab = bab+1;
    gab = A(:,bab);
    gaba = gab-gab(1);
    truck = A(:,dab);
    trucka = truck-truck(1);
    hold on
    plot(gaba,trucka,"linewidth",.3,"Color",[.5 .5 rand(1)]);
    axis([-2 2 -2 2]);
    axis equal
%     saveas(psst,sprintf('cables%d.png',bab));
end
hold off
%this makes a random scatter plot of the first 100 tracks

% figure
% 
% for ll=1:2:150;
%     bb=ll+1;
%     gettrack=A(:,ll);
%     zerotracks = gettrack-gettrack(1);
%     randomstrack = abs(zerotracks+(5*rand(1)));
%     gettracky=A(:,bb);
%     zerotracksy = gettracky-gettracky(1);
%     randomtracky = abs(zerotracksy+(10*rand(1)));
%     hold on
%     plot(randomstrack,randomtracky,"linewidth",.3,"Color",[rand(1) rand(1) rand(1)])
%     axis equal
% end


% 

VeloPos = velorho;
VeloPos(VeloPos==0)=[];
[ksdensityf,ksdensityx]=ksdensity(VeloPos,"support",[0,1.1],"function","pdf");
figure
histogram(VeloPos,50,"normalization","pdf")

figure
plot(ksdensityx,ksdensityf)
