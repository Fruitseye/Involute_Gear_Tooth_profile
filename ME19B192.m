%Given values%
theta_press=20*pi/180;
N=20;
r_p=100;

%Relation between pitch radius and base radius
r_b=100*cos(theta_press);

%Initialising radius ranging from base radius circle to addendum circle
r=linspace(r_b,r_p+10,100);

%Initializing empty varaibles
phi=zeros(1,100);
thick=zeros(1,100);
theta_1=zeros(1,100);
x=zeros(1,100);
y=zeros(1,100);

rot=2*pi/N; %Rotation need for 20 teeths(equal 18 degrees)
rot_90=pi/2; %Rotating by 90 degrees,since 4 teeth subtend 90 degrees

%Rotation matrix for each part
M=[cos(rot) -sin(rot);sin(rot) cos(rot)]; % 4 teeth
M_90=[cos(rot_90) -sin(rot_90);sin(rot_90) cos(rot_90)];  % 20 teeth

%Loop that stores x and y values for one of the tooth's involute profile
for i=1:100
    phi(i)=acos(r_b/r(i));
    thick(i)=2*r(i).*((pi/(2*N))+tan(theta_press)-theta_press-tan(phi(i))+phi(i));
    theta_1(i)=thick(i)/r(i);
    x(i)=r(i)*sin(theta_1(i)/2);
    y(i)=r(i)*cos(theta_1(i)/2);
end
plot(x,y)
non_inv_x=8.415 %x value at Intersection of dedendum circle and Line tangent to involute(found by plotting)

%%Finding NON-INVOLUTE PART since dedendum circle radius is less than base circle radius
Slope=(y(1)-y(2))/(x(1)-x(2)); %Finding slope using two nearby points
line_x=linspace(non_inv_x,x(1),100);
line_y=Slope.*(line_x-x(2))+y(2);

%Circular part of gear(dedendum circle)
Circ_x=linspace(-x(1),-line_y(1),50);
Circ_y=sqrt((87.5^2)-Circ_x.^2);   %87.5 is dedendum circle radius
%Circ_x=0;
%Circ_y=0;

%Concatenating all the parts(Involute,non-Involute line,Quarter circle)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5For 4 teeth
x_90=cat(2,line_x,x,-fliplr(x),-fliplr(line_x),Circ_x);
y_90=cat(2,line_y,y,fliplr(y),fliplr(line_y),Circ_y);

%Rotating x and y values 3 times to get the remaining profile
%For 4 teeth
z1=M_90*[x_90;y_90];
z2=M_90*z1;
z3=M_90*z2;
hold on
%Final concatenation
x_90=cat(2,x_90,z1(1,:),z2(1,:),z3(1,:));
y_90=cat(2,y_90,z1(2,:),z2(2,:),z3(2,:));
figure(1)
plot(x_90,y_90)

%For complete gear with 20 teeth
figure(2)
x=cat(2,line_x,x,-fliplr(x),-fliplr(line_x));
y=cat(2,line_y,y,fliplr(y),fliplr(line_y));
th = 0:pi/50:2*pi;
xunit = 87.5 * cos(th);
yunit = 87.5* sin(th);
plot(xunit,yunit,'black');
hold on
for i=1:20
    z=M*[x;y];
    plot(x,y,'b','Linewidth',1.5)
    hold on
    x=z(1,:);
    y=z(2,:);
end
%plot(x,y,'b','Linewidth',1.5);
hold on

xlim([-150,150]);
ylim([-150,150]);
