/*
 * scrolltest.prg by Mike
 * (c) 2023 LUL
 */

PROGRAM scrolltest;

const
m_none = 0;
m_falling = 1;
m_walking = 2;
m_bounce = 3;
m_jump = 4;
m_hop = 5;
m_air = 6;

GLOBAL

level;

BEGIN

//Write your code here, make something amazing!
load_fpg("mappy.fpg");
set_mode(224288);
set_fps(60,0);

level = 1;

//set_mode(m320x240);
define_region(1,0,16,224,256);
start_scroll(0,file,0,300+level,1,0);

/*
define_region(2,0,120,320,60);
start_scroll(1,file,300,301,2,0);

define_region(3,0,180,320,60);
start_scroll(2,file,300,301,3,0);
*/
//graph=100;
scroll.camera = mappy();
sprite(120,160,100);

trampolines();

loop
frame;
end

end

process trampolines()

private
px;
py;


begin

    for (x=1;x<10;x++)
        get_point(file,300+level,x, &px,&py);
        if (px < 65000 && px > 0 && py > 60)
            trampoline(px+14,py+2);
        end
    end
end

process trampoline(x,y)

begin

ctype=c_scroll;

graph = 500;

loop
frame;
end


end


process mappy();

private
state;
dir;
i;
textid;

animcount = 0;
begin
graph=100;
ctype=c_scroll;
region=0;
x=100;
y=100;
state = m_none;
dir = 0;

loop

    delete_text(textid);
    animcount++;
    if(animcount == 4)
        animcount = 0;
    end

    if(state == m_none or state == m_walking)

        if(key(_left))
            flags=0;
            dir=-1;
            state = m_walking;
        end

        if(key(_right))
            flags=1;
            dir=1;
            state = m_walking;
        end

    end

    switch (state)

        case m_air:
            textid = write(0,0,20,3,"State: Airtime");
            y--;
            frame;
            y--;
            frame(200);
            y++;
            frame;
            y++;
            frame;
            state = m_none;
        end

        case m_none:
            textid = write(0,0,20,3,"State: None");
            graph = 101;
            if(map_get_pixel(file,400+level,x,y+8) !=251)
                state = m_falling;
            end

        end

        case m_bounce:
            textid = write(0,0,20,3,"State: Bouncing");

            if(map_get_pixel(file,400+level,x,y+10) == 38)
                if (key(_left))
                    dir = -1;
                    state = m_hop;
                    flags = 0;
                end

                if (key(_right))
                    dir = 1;
                    state = m_hop;
                    flags = 1;
                end

                if (state == m_hop)

                    graph = 100;

                    while(map_get_pixel(file,400+level,x,y+10)==30)
                        y-=2;
                        frame;
                    end
                    y-=2;
                    x+=dir;
                    frame;
                    y-=1;
                    x+=dir;
                    frame;
                    y-=1;
                    x+=dir;
                    frame;

                  // y-=2;
                  // x+=dir;
                  // frame;
                  x+=dir;
                  y-=2;

                end

            end

            if (state != m_hop)
                if(y>66)
                    y-=2;
                    if(animcount == 0)
                        if (graph == 102)
                            graph = 103;
                        else
                            graph = 102;
                        end
                    end

                else
                    state = m_air;
                end
            end


        end

        case m_falling:

            textid = write(0,0,20,3,"State: Falling");

            // nothing we can do except land on a trampoline
            if(map_get_pixel(file,400+level,x,y+10) ==251)
                state = m_none;
            end

            y+=2;
            if(animcount == 0)
                if (graph == 102)
                    graph = 103;
                else
                    graph = 102;
                end
            end

            if(collision(type trampoline))
                state = m_bounce;

            end


        end

        case m_walking:
            textid = write(0,0,20,3,"State: Walking");

            x+=dir;
            if(!key(_left) and !key(_right))
                state = m_none;
            end

            if(animcount ==0)
                if(graph == 100)
                    graph = 101;
                else
                    graph = 100;
                end
            end

            if(map_get_pixel(file,400+level,x,y+10) !=251)
                state = m_hop;
            end

        end

        case m_hop:
            textid = write(0,0,20,3,"State: Hopping");

            // more happens here
            graph = 100;

            y-=1;
            frame;

            y-=1;
            frame;

            x+=dir;
            y-=1;
            frame;

            y-=1;
            frame;

            x+=dir;
            y-=1;
            frame;

            x+=dir;
            y-=1;
            frame;

            x+=dir;
            frame;

            x+=dir;
            y-=1;
            frame;

            x+=dir;
            frame;

            x+=dir;
            frame;

            x+=dir;
            frame;

            x+=dir;
            frame;

            x+=dir;
            y+=1;
            frame;

            x+=dir;
            frame;

            x+=dir;
            y+=1;
            frame;

            x+=dir;
            y+=1;
            frame;

            y+=1;
            frame;

            x+=dir;
            y+=1;
            frame;

            y+=1;
            frame;

            state = m_falling;
            graph = 102;
            animcount =0;
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

