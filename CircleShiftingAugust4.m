XYshiftdown = circshift(XY,-1)
XYShifted = XYshiftdown(1:49,1:2)
XYResize = XY(1:49,1:2)


%so a mag gets the  displacement per step (sqrt((x1-xo)^2+(y1-yo)^2)))
Amag=vecnorm(XYShifted-XYResize,2,2)

%a shift gets the sum of the absolute value ov |x1-x0| +
%|y1-y0]
Aval=vecnorm(XYShifted-XYResize,1,2)

XYzeroed = XYShifted-XYResize
[VecAngle VecMag]=cart2pol(XYzeroed(:,1),XYzeroed(:,2))
