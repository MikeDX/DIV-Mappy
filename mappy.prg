PROGRAM example_load_sound;

PRIVATE
    id_sound;

BEGIN
    set_mode(224288);
    set_fps(60,2);
    //clear_screen
    //define_region(1,0,0,224,288);
    //region = 1;
    //set_mode(m244x288);
    load_fpg("mappy.fpg");
    write_int(0,0,0,0,offset timer[0]);

    //graph=4;
    //x=112;
    //y=144;
    high_score();
    one_up();
    intro();

    loop
    frame;
    end

 end
function delay(x)

begin


end


process intro()


private

npid;
cpid;
stid;
mlid;

begin


    put_screen(file,6);

    frame(1000);

    npid=namco_presents();

    y = timer[9]+100;

    while(timer[9]<y);
        frame;
    end


    mlid=mappy_logo();


    y = timer[9]+100;

    while(timer[9]<y);
        frame;
    end

    //delay(2);


    cpid=copyright();

    y = timer[9]+100;

    while(timer[9]<y);
        frame;
    end

//    delay(2);

    stid = starring();
    x=252;

    while (x>0);
       npid.x-=2;
       cpid.x-=2;
       stid.x-=2;
       frame;
       x-=2;

    end


    cpid=copyright();

    y = timer[9]+100;

    while(timer[9]<y);
        frame;
    end

    while (mlid.y < 144)
        mlid.y+=4;
        frame;
    end


    loop
    frame;
    end

end


process start()
private
id_sound;

begin
    LOOP
        if(!is_playing_sound(id_sound))
        IF (scan_code==_space)
            sound(id_sound, 100, 256);
            mappy(209,248);
            //x = 200;
            //y = 250;
        END
        else
        end

        FRAME;
    END
END


process high_score()

begin

graph=200;
y=3;
x=112;
loop
frame;

end

end

process one_up()

begin

graph=202;
y=3;
x=36;

loop
frame;
end

end

process namco_presents()

begin

graph=201;
y=43;
x=113;

loop
frame;
end

end


process mappy_logo()

begin

graph=2;
x=113;
y=88;


flags=4;


loop
    frame;
end

end


process copyright()

begin

graph=5;
x=115;
y=220;
loop
    frame;
end

end

process starring()

begin

graph=7;
x=113+252;
y=27;
loop
    frame;
end

end





process mappy(x,y)

begin

region=1;
graph=100;
loop
        x--;
        if(x mod 4 == 0)
            graph++;
            if(graph==102);
                graph=100;
            end
        end
        if (x < -16)
        return;
        end

frame;

end


end

