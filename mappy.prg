PROGRAM example_load_sound;

GLOBAL

id_intro;
credits = 0 ;
credit_sound;
id_sound;
playing = false;

PRIVATE



BEGIN
    set_fps(60,2);
    load_fpg("mappy.fpg");

    set_mode(224288);
    define_region(1,0,32,224,256);
    start_scroll(0,file,300,301,1,15);
    //scroll[0].y1 = -64;
    id_sound=load_sound("intro.ogg",0);
    credit_sound=load_sound("credit.ogg",0);

    write_int(0,0,0,0,offset credits);

    loop
        high_score();
        one_up();



        id_intro = intro();

        // check for coinage
        credit();

        //??? do something here

        while (credits == 0)
            frame;
        end

        signal(id_intro,s_kill_tree);

        pselect();

        while(!playing)
            frame;
        end


        //playing = false;

        while(playing)
            frame;
        end

    //    loop
      //      frame;
        //end
        frame;

        let_me_alone();


    end



end

process pselect();

begin

graph = 9;
x = 340;
y = 148;


    while(!key(_1) and !key(_2))
        if (x > 114)
            x-=4;
        end
        scroll.y0++;
        scroll.x1++;
        frame;

    end

    playing = true;
    credits = 0;
    start();

end




process credit()

begin

    loop

        if(key(_space))
            sound(credit_sound, 100, 256);

            credits++;
            //frame;

            while(key(_space))
                frame;
            end

        end

        frame;
    end

end

process intro()


private

npid;
cpid;
stid;
mlid;

begin


    //put_screen(file,6);

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



    y = timer[9]+100;

    while(timer[9]<y);
        frame;
    end

    mappyi();

    while (mlid.y < 144)
        mlid.y+=4;
        frame;
    end


    loop
    frame;
    end

end

process mappyi()

begin

    graph=8;
    x=114;
    y=105;

    loop

        frame;

    end

end

process start()


begin
graph = 53;
x = 111;
y = 264;

    sound(id_sound, 100, 256);
    mappy(209,248);
    goro(174,248);
    meowky(121,248);
    meowky(97,248);
    meowky(73,248);

    loop
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


//flags=4;

z=-10;

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


process goro(x,y)

begin

graph = 120;
flags=4;
loop

x--;

frame;

end

end

process meowky(x,y)

begin

graph = 130;
flags=4;
loop
x--;
frame;

end

end





process mappy(x,y)

begin

//scroll.camera = id;
graph=100;
region=1;
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

