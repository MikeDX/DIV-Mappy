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
m_knocked = 7;
m_intro = 8;
m_what = 9;

GLOBAL

level;
miss_sound;
jump_sound;
intro_sound;
start_sound;
ingame_sound;
credit_sound;

scroll_map;
LOCAL

// for trampolines
hit = 0;
broken = 0;
health;

BEGIN

//Write your code here, make something amazing!
load_fpg("mappy.fpg");
set_mode(224288);
set_fps(60,0);
frame(6000);
//fade_on();

level = 1;

miss_sound = load_sound("miss.ogg",0);
jump_sound = load_sound("tramp_jump.ogg",0);
intro_sound = load_sound("intro.ogg",0);
start_sound = load_sound("game_start.ogg",0);
ingame_sound = load_sound("ingame.ogg",1);

//set_mode(m320x240);
define_region(1,0,16,224,256);
scroll_map = new_map(480,256,240,128,0);
map_put(file,scroll_map,300+level,240,128);
start_scroll(0,file,0,scroll_map,1,0);
start_scroll(1,file,0,350,1,0);

/*
define_region(2,0,120,320,60);
start_scroll(1,file,300,301,2,0);

define_region(3,0,180,320,60);
start_scroll(2,file,300,301,3,0);
*/
//graph=100;
mappy();
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
            trampoline(px+14,py+5);
        end
    end
end

process trampoline(x,y)


begin
hit = false;
broken = false;

ctype=c_scroll;
//cnumber=1;
graph = 500;
health = 3;
loop

if (hit == true)
    sound(jump_sound,128,256);

    if(health > 0)
    graph=501 + (3-health)*4;
    frame;
    graph++;
    frame;
    graph++;
    frame;
    graph--;
    frame;
    graph--;
    frame;
    graph--;
    frame;
    flags=2;
    graph++;
    frame;
    graph++;
    frame;
    graph--;
    frame;
    graph--;
    frame;
    flags=0;
    end

    hit=0;
    if(health > 0)
        health--;
        graph = 500 + (3-health)*4;
    else
        graph = 516;
    end
end

if (hit == 2)
    health = 3;
    graph = 500;
    hit = 0;
end


frame;
end


end


process mappy();

private
state;
dir;
i;
j;
textid;
animcount = 0;
tramp_id;
bounced_id;
intro;
begin
graph=100;
ctype=c_scroll;
cnumber=0;
region=0;
x=464;
y=232;
scroll.x0 = 480;
state = m_intro;
dir = -1;
intro = 1;

//frame;

//scroll.camera = id;
//loop
//frame;
//end




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

        if(bounced_id)
            bounced_id.hit = 2;
            bounced_id = 0;
        end

    end

    switch (state)


        case m_intro:
            textid = write(0,0,20,3,"State: Intro");

            // draw black wall
            map_put(file,scroll_map,350,452,228);
            refresh_scroll(0);
            scroll.x0 = 480;

            // wait a second
            frame(6000);
            sound(start_sound,128,256);

            state = m_walking;

        end

        case m_what:
            textid = write(0,0,20,3,"State: What?");

            map_put(file,scroll_map,351,452,228);
            refresh_scroll(0);
            graph=100;
            frame;
            graph=101;

            while(scroll.x0 > 234)
                scroll.x0--;
                frame;
            end

            //frame(6000);
            flags = 1;

            frame(3000);

            bounced_id.hit = 1;
            frame(2000);
            bounced_id.hit = 2;

            /*
            while(x>418);
                x-=2;
                frame;

            end
            */


//loop
//frame;
//end


            unload_map(scroll_map);

            stop_scroll(0);
//frame;

            scroll_map = new_map(458,256,240,128,0);
            map_put(file,scroll_map,300+level,240,128);
            start_scroll(0,file,0,scroll_map,1,0);
            scroll.camera = id;

            frame(3000);
            flags = 0;
            frame(6000);

            state = m_none;
            intro = 0;

            sound(ingame_sound,128,256);

            //loop
            //    frame;
            //end

        end


        case m_knocked:
            stop_sound(-1);
            textid = write(0,0,20,3,"State: Knocked");

            graph = 104;
            flags = 0;
            //debug;
            frame(6000);
            sound(miss_sound,128,256);
            for(i=0;i<4;i++)
                angle = 0;
                for(j=0;j<4;j++)
                    graph = 106;
                    frame(200);
                    graph = 107;
                    frame(200);
                    angle -=90000;
                end
            end

            for(i=0;i<8;i++)
                graph = 108;
                frame(200);
                graph = 109;
                frame(200);
            end

            frame(6000);
            loop
                frame;
            end

        end


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
            state = m_falling;
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
                if (key(_left) or intro)
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

                    graph = 105;

                    while(map_get_pixel(file,400+level,x,y+6)==30)
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
                y-=2;
                if(!collision(type trampoline) && map_get_pixel(file,400+level,x,y-12) != 235)
                //    y-=2;
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
                if(intro)
                    state = m_what;
                    graph = 100;
                end
            end

            y+=2;
            if(animcount == 0)
                if (graph == 102)
                    graph = 103;
                else
                    graph = 102;
                end
            end

            tramp_id = collision(type trampoline);
            if(tramp_id)
                if(!intro)
                    tramp_id.hit = 1;
                end

                bounced_id = tramp_id;
                if(tramp_id.health > 0)
                    state = m_bounce;
                    for(i=0;i<2;i++)
                        frame;
                        y+=2;
                    end

                    for(i=0;i<2;i++)
                        frame;
                        y-=2;
                    end

                end
            end

            if(y>246)
                state = m_knocked;
            end


        end

        case m_walking:
            textid = write(0,0,20,3,"State: Walking");

            x+=dir;
            if(!key(_left) and !key(_right) and !intro )
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
            if(intro)
                graph = 107;
            else
                graph = 105;
            end

            y-=1;
            frame;

            y-=1;
            frame;

            x+=dir;
            y-=1;
            frame;

            y-=1;
            frame;
            //debug;
            if((x<16 or x > 439) and !intro ) // left and right playfield boundaries
                if(dir == 1)
                    dir = -1;
                else
                    dir = 1;
                end
            else


                x+=dir;
                y-=1;
                frame;

                x+=dir;
                y-=1;
                frame;

            // at this point we could be hitting a wall or a closed door

            // check wall



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

            end


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

            //x+=dir;
            y+=1;
            frame;

            y+=1;


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

