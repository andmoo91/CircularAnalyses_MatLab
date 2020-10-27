%% This accessess the folders where I stored the 32 bit NaN bground cable binaries
%basiclly this script takes the orientation maps and multiplies them by the
%32 bit nan background binaries to get orientation maps for the cables. I
%plan to extract theta diffs

close all
%I want to take the mito binary, multiply it by mito orientation and local
%cable orientation then correlate the two
myFolder = '/Users/asmoore/Desktop/OctoberOrientationFinal/Mitochondria_rotated45/c45Mito32Bit';
myFolder2 = '/Users/asmoore/Desktop/OctoberOrientationFinal/Mitochondria_rotated45/c45MitoOrientation';
myFolder3 = '/Users/asmoore/Desktop/OctoberOrientationFinal/AllCables/CableOrientationMaps';


filePattern = fullfile(myFolder,'*.tif'); % 32bit mito cables
filePattern2 = fullfile(myFolder2,'*.tif'); % MitoOrientationMAp
filePattern3 = fullfile(myFolder3, '*.tif'); %CableOrientationMap
theFiles = dir(filePattern); %32bit mito binary
theFiles2 = dir(filePattern2); % mito orientation map
theFiles3 = dir(filePattern3); % cable orientation map

figure

for k=1:length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    baseFileName2 = theFiles2(k).name;
    fullFileName2 = fullfile(theFiles2(k).folder,baseFileName2);
    baseFileName3 = theFiles3(k).name;
    fullFileName3 = fullfile(theFiles3(k).folder,baseFileName3);
    fprintf(1,"Now reading %s\n", fullFileName);
    fprintf(1,"Now readins %s\n", fullFileName2);
    fprintf(1,"Now reading %s\n", fullFileName3);
    imageArray = imread(fullFileName);
    imageArray2 = imread(fullFileName2);
    imageArray3 = imread(fullFileName3);
    
    % now i get pixel size info
    pixinfo = imfinfo(fullFileName);
    pixsize=pixinfo.YResolution;
    pixelsize = 1./pixsize;
    
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
  
    %Getting the double info for each image
    MitoBinary32 = double(imageArray);
    MitoOrientationMap = double(imageArray2);
    CableOrientationMap = double(imageArray3);
   
    MitoOrientationBinary = MitoBinary32.*MitoOrientationMap; %here i finally multtiply the images by one another to get the EDM local maxima
    CableOrientationBinary = MitoBinary32.*CableOrientationMap;
    [X Y V]=find(MitoOrientationBinary);
    [X1, Y1, V1] = find(CableOrientationBinary);
 

    V(isnan(V))=[]; %this gets rid of any nan values
    V1(isnan(V1))=[]; %this dnans the mito x cable
    T(:,k)=corr(V,V1);
    
   % Xmax = max(X)-2;
    %Xmin = min(X)+2;
    %Ymax = max(Y)-2;
    %Ymin = min(Y)+2; %thes operations just find the edges and a bit of the image

    %FilteredV = V(V<20);
    %FilteredX = X(V<20);
    %FilteredY = Y(V<20); %these simply filter out edge values
    %FilteredV = double(FilteredV)
    %ScaledV = FilteredV*pixelsize;
    %ScaledX = FilteredX*pixelsize;
    %ScaledY = FilteredY*pixelsize;
    
    MitoOrientationValues(1:length(V),k)=V;
    CableOrientationValues(1:length(V1),k)=V1;
    
    %figure
    %scatter(FilteredX,FilteredY,50,FilteredV)
    
    
    DoubleV = V*2;
    DoubleV1 = V1*2;
    CoOrientation(:,k) = circ_corrcc(DoubleV,DoubleV1)
    CoOrientationHalf(:,k) = circ_corrcc(V,V1);
    
    
    
    %Here i will get the angle difference between DoubleV (mito pixels
    %mitoi map) and doubleV1 (mitopixels cableOrientationMap). I multipled
    %by two to solve the cross over problem.
    
    
    
    
    
    VMeanAxis(:,k) = circ_mean(DoubleV);
    V1MeanAxis(:,k) = circ_mean(DoubleV1);
    
    
    
    
    DiffV = circ_dist(DoubleV,DoubleV1);
    BackCalculatedDiffV = DiffV./2;
    MeanDifference = mean(BackCalculatedDiffV);
    MeanDifferences (:,k) = MeanDifference;
    AllDifferences(1:length(V),k)= BackCalculatedDiffV;
  
    CrossCorr(:,k) = corr2(MitoOrientationMap,CableOrientationMap);
    
    
%     Reor = DoubleV-MeanAxis
%     ReorBack = Reor./2
%     ReorientationValues(1:length(ReorBack),k)=ReorBack
%     read_axis(:,k)=MeanAxis
    
    
    %c=V
    %figure
    %polarhistogram(ReorBack,12)
    %colorbar
    %hold on
end

MeanAngleShifts = abs(rad2deg(MeanDifferences))'
AllAngleDiffs1 = rad2deg(abs(AllDifferences(:)));
AllAngleDiffFinal = AllAngleDiffs1(AllAngleDiffs1>0);
