%% This accessess the folders where I stored the ultimate points and the distance maps
%basiclly this script takes the point localizations of the center of each
%node and multiplies it by the euclidean distance maps to calcualte
%essentially the size of each pore.  I filter for edge effects by
%subtracitun the 1-3 pix along the x and y boundaries

close all

myFolder = '/Users/asmoore/Desktop/LatACisternalization/CisternaUltima';
myFolder2 = '/Users/asmoore/Desktop/LatACisternalization/CisternaEDM';
filePattern = fullfile(myFolder,'*.tif'); % ultimate points
filePattern2 = fullfile(myFolder2,'*.tif'); % EDMS
theFiles = dir(filePattern); %UPs
theFiles2 = dir(filePattern2); %EDMs

figure

for k=1:length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    baseFileName2 = theFiles2(k).name;
    fullFileName2 = fullfile(theFiles2(k).folder,baseFileName2);
    fprintf(1,"Now reading %s\n", fullFileName)
    fprintf(1,"Now readins %s\n", fullFileName2)
    imageArray = imread(fullFileName);
    imageArray2 = imread(fullFileName2);
    
    % now i get pixel size info. they should be the same so i only read
    % from the first to save space
    pixinfo = imfinfo(fullFileName);
    pixsize=pixinfo.YResolution;
    pixelsize = 1/pixsize;
    %figure
    %imagesc(imageArray)
    %turbomap
    %colormap(gca,turbo)
    %colorbar
    %figure
    %imagesc(imageArray2)
    %colormap(gca,turbo)
    %colorbar
    %imshow(imageArray); %display the image
    Ultimate = imageArray;
    [ux uy uv]=find(Ultimate);
    maxuv(k,1)=max(uv);
    EDM = imageArray2;
    Ult_EDM = Ultimate.*EDM; %here i finally multtiply the images by one another to get the EDM local maxima
    %figure
    %imagesc(Ult_EDM)
    [X Y V]=find(Ult_EDM);
    V(isnan(V))=[];
    V = double(V);
    %this gets rid of any nan values that might have snuck in there for some reason
%     Xmax = max(X)-2;
%     Xmin = min(X)+2;
%     Ymax = max(Y)-2;
%     Ymin = min(Y)+2; %thes operations just find the edges and a bit of the image

%     FilteredV = V(X<Xmax & X>Xmin & Y<Ymax & Y>Ymin);
%     FilteredX = X(X<Xmax & X>Xmin & Y<Ymax & Y>Ymin);
%     FilteredY = Y(X<Xmax & X>Xmin & Y<Ymax & Y>Ymin); %these simply filter out edge values
%      FilteredV = double(FilteredV)
    ScaledV = V.*pixelsize;
    ScaledX = X.*pixelsize;
    ScaledY = Y.*pixelsize;
    AreaV = pi*(ScaledV).^2 % v is largest fitting circle radius. we use pi*r^2 to get area
    
    EDMValues(1:length(ScaledV),k)=ScaledV;
    EDMAreaValues(1:length(AreaV),k)=AreaV;
    XVal(1:length(ScaledX),k) = ScaledX;
    YVal(1:length(ScaledY),k) = ScaledY;
    EDMMeans(k,1)=mean(ScaledV);
    EDMMeansArea(k,1)=mean(AreaV);
    EDMMedian(k,1)=median(ScaledV);
    EDMMedianArea(k,1)=median(AreaV);
    EDMStd(k,1)=std(ScaledV);
    EDMStdArea(k,1)=std(AreaV);
    EDMVar(k,1)=var(ScaledV);
    EDMVarArea(k,1)=var(AreaV)
    EDMVar2MeanArea(k,1)=var(AreaV)/mean(AreaV);
    EDMMad(k,1)=mad(ScaledV);
    EDMMadArea(k,1)=mad(AreaV);
    EDMCount(k,1)=length(ScaledV);
    PixVals(k,1)=pixelsize;
    EDMMax(k,1)=max(ScaledV);
    EDMMaxArea(k,1)=max(AreaV);
    c=40*V;
    
    scatter(ScaledX,ScaledY,c,ScaledV,"filled")
    colorbar
    hold on
    
end

EDMAll = EDMValues(:);
EDMAll = EDMValues(EDMValues~=0);
EDMAllArea = EDMAreaValues(:);
EDMAllArea = EDMAreaValues(EDMAreaValues~=0);
figure
histogram(EDMAll)
XYpositionsAll = reshape([XVal;YVal], size(XVal,1), []);
EDMOutput = [EDMMeansArea EDMMedianArea EDMStdArea EDMVarArea EDMVar2MeanArea EDMMadArea EDMCount EDMMaxArea];
TitleOutput = ["Mean cisterna area" "EDMMedianArea" "STDev cisterna area" "Cisterna area variance" "Cisterna Var2Mean ratio" "Cisterna MAD" "CisternaCount" "Cisterna Max Area"]
EDM_All = [TitleOutput;EDMOutput];


AllCistCircleFit = (EDMAll.^2)*pi;