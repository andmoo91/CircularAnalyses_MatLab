OutVecSD = zeros(1,78)
OutVecShift = zeros(1,78)
ResLength = zeros(1,78)
RadialMean = zeros(1,78)

for k = 1:3:size(A,2)
    l = k+1
    m = k+2
    CartX = A(:,k)
    CartY = A(:,l)
    CartZ = A(:,m)
    CartX(isnan(CartX))=[]
    CartY(isnan(CartY))=[]
    CartZ(isnan(CartZ))=[]
    
    [Azimuth Elevation Rho] = cart2sph(CartX,CartY,CartZ);
    Azimuth_Degrees = rad2deg(Azimuth)+180
    Elevation_Degrees = rad2deg(Elevation)
    W1 = (Azimuth_Degrees>=0 & Azimuth_Degrees<120 & Elevation_Degrees<0 & Rho>0)
    W2 = (Azimuth_Degrees>=120 & Azimuth_Degrees<240 & Elevation_Degrees<0 & Rho>0)
    W3 = (Azimuth_Degrees>=240 & Azimuth_Degrees<360 & Elevation_Degrees<0 & Rho>0)
    W4 = (Azimuth_Degrees>=0 & Azimuth_Degrees<120 & Elevation_Degrees>=0 & Rho>0)
    W5 = (Azimuth_Degrees>=120 & Azimuth_Degrees<240 & Elevation_Degrees>=0 & Rho>0)
    W6 = (Azimuth_Degrees>=240 & Azimuth_Degrees<360 & Elevation_Degrees>=0 & Rho>0)
    Wedges = [sum(W1);sum(W2);sum(W3);sum(W4);sum(W5);sum(W6)]
    WedgePercent = 100*(Wedges/sum(Wedges))
    SD_Wedge_Percent = std(WedgePercent)
    OutVecSD(:,k) = SD_Wedge_Percent
    
    ThreeDcentershift = sqrt(mean(CartX)^2+mean(CartY)^2+mean(CartZ)^2)
    OutVecShift(:,k) = ThreeDcentershift
    
    
    l2=cos(Azimuth).*cos(Elevation)
    m2 = sin(Azimuth ).*cos(Elevation)
    n2 = sin(Elevation)
    SphereResVectLeng = sqrt(sum(l2)^2+sum(m2)^2+sum(n2)^2)/size(l2,1)
    ResLength(:,k) = SphereResVectLeng
    RadialMean(:,k)=mean(Rho)
    
end

SD_of_Wedges_All = OutVecSD(:,1:3:end)'
ThreeDCenterShiftOut = OutVecShift(:,1:3:end)'
ResultantVectorLength = ResLength(:,1:3:end)'
MeanDistanceFromCenter = RadialMean(:,1:3:end)'



% sz = 100
% 
% figure
% surf(X2,Y2,Z2,'EdgeColor','none',"FaceAlpha",0.2)
% hold on
% scatter3(CartX,CartY,CartZ,sz,"filled")
% axis equal
% 
% W1x = CartX(W1)
% W1y = CartY(W1)
% W1z = CartZ(W1)
% 
% scatter3(W1x,W1y,W1z,sz,"filled",'g','MarkerEdgeColor','k')
% hold on
% 
% W2x = CartX(W2)
% W2y = CartY(W2)
% W2z = CartZ(W2)
% 
% scatter3(W2x,W2y,W2z,sz,"filled",'b','MarkerEdgeColor','k')
% 
% W3x = CartX(W3)
% W3y = CartY(W3)
% W3z = CartZ(W3)
% 
% scatter3(W3x,W3y,W3z,sz,"filled",'r','MarkerEdgeColor','k')
% 
% W4x = CartX(W4)
% W4y = CartY(W4)
% W4z = CartZ(W4)
% 
% scatter3(W4x,W4y,W4z,sz,"filled",'y','MarkerEdgeColor','k')
% 
% W5x = CartX(W5)
% W5y = CartY(W5)
% W5z = CartZ(W5)
% 
% scatter3(W5x,W5y,W5z,sz,"filled",'m','MarkerEdgeColor','k')
% 
% W6x = CartX(W6)
% W6y = CartY(W6)
% W6z = CartZ(W6)
% 
% scatter3(W6x,W6y,W6z,sz,"filled",'c','MarkerEdgeColor','k')