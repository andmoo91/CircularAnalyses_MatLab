TimeMin=ResVec(:,1)
ResTheta=ResVec(:,2)
ResLength=ResVec(:,3)
J = max(TimeMin)

for i=1:J
    coco = [1-(i/(2*J)) .5 i/J]
    OrangeToBlue(i,:)=coco
end
figure
polarscatter(ResTheta,ResLength,125,TimeMin,"filled","MarkerFaceAlpha",.7,"MarkerEdgeColor",[.4 .4 .4])
colormap(OrangeToBlue)
figure
scatter(ResTheta,ResLength,125,TimeMin,"filled","MarkerFaceAlpha",.5,"MarkerEdgeColor",[.1 .1 .1])
axis([-pi/2 pi/2 0 1])
colormap(OrangeToBlue)
grid on
colorbar

%the colormap should be given the opacity treatment too