/*
 * scrolltest.prg by Mike
 * (c) 2023 LUL
 */

PROGRAM scrolltest;

BEGIN

//Write your code here, make something amazing!
load_fpg("mappy.fpg");
set_mode(224288);
set_fps(60,0);
//set_mode(m320x240);
define_region(1,0,16,224,256);
start_scroll(0,file,0,300,1,0);

/*
define_region(2,0,120,320,60);
start_scroll(1,file,300,301,2,0);

define_region(3,0,180,320,60);
start_scroll(2,file,300,301,3,0);
*/
//graph=100;
scroll.camera = mappy();
sprite(120,160,100);


loop
frame;
end

end

process mappy();

begin
graph=100;
ctype=c_scroll;
region=0;
x=200;

y=100;
loop

if(key(_left))
flags=0;
x-=2;
end

if(key(_right))
flags=1;
x+=2;
end

if(key(_up))
y-=2;
end

if(key(_down))
    if(map_get_pixel(file,400,x,y+8)!=251)
        y+=2;
    end

end


frame;

end





END




process sprite(graph,x,y)

private
mappy_id;
an;
begin
ctype=c_scroll;
region=0;
write_int(0,8,8,4,&an);
loop

mappy_id = get_id(type mappy);

if(get_dist(mappy_id) < 50)
an=get_angle(mappy_id);

x+=rand(-1,1);
end

//if(get_distx x+=rand(-1,1);
frame;

end

end

