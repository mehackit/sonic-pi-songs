#  HALLOWEEN + JOHN CARPENTER + SONIC PI + MEHACKIT #

use_bpm 140
use_synth :subpulse
use_synth_defaults amp: 1.3

notes1 = [:Db6, :Gb5, :Gb5, :Db6, :Gb5, :Gb5, :Db6, :Gb5, :D6, :Gb5].ring
notes1R = [:Db6, :Gb5, :Gb5, :Db6, :Gb5, :Gb5, :Db6, :Gb5, :D6, :r].ring
notes2 = [:C6, :F5, :F5, :C6, :F5, :F5, :C6, :F5, :Db6, :F5].ring
notes3 = [:B5, :E5, :E5, :B5, :E5, :E5, :B5, :E5, :C6, :E5].ring
notes4 = [:Bb5, :Eb5, :Eb5, :Bb5, :Eb5, :Eb5, :Bb5, :Eb5, :B5, :Eb5].ring
notes5 = [:Gb5, :B4, :B4, :Gb5, :B4, :B4, :Gb5, :B4, :G5, :B4].ring

amp_mod = range(0.55, 1.0, 0.025).mirror
pan_mod = range(-0.4, 0.4, 0.01).mirror
introFade = line(0.2, 1.0, steps: 40)
outroFade = line(1.0, 0.0, steps: 160)

def p(note, s, a: 1.0)
  play note, release: s, amp: 1.0*a, pan: [-0.25, 0.25, -0.5, 0.5].ring.look
  sleep s
  with_fx :echo, mix: 0.25 do
    with_synth :piano do
      play note, release: s, amp: 0.85*a, pan: rrand(-0.25, 0.25)
    end
  end
end

def pl(note, r, modulation: 0)
  play note, release: r, amp: 0.5
  with_synth :sine do
    play note-12, release: r, amp: 0.6
  end
  with_fx :echo, phase: 0.75, decay: 3, mix: 0.5 do
    with_fx :hpf, cutoff: 75 do
      with_synth :piano do
        play note+modulation, attack: 0.2, release: r-1.0, amp: 1.15, pan: [0,25, -0.5, 0.5, -0.25].ring.look
      end
    end
    with_fx :lpf, cutoff: 90 do
      with_fx :band_eq, mix: 1.0, freq: 300, db: -6, res: 0.5 do
        with_synth :prophet do
          play note+12+modulation, attack: 0.5, release: r-0.5, amp: 0.8, pan: rrand(-0.35, 0.35)
        end
      end
    end
  end
end

def playPart(notes)
  10.times do
    note = notes.tick
    p note, 0.5
  end
end

def playPartWithFade(notes, fade: 1.0)
  10.times do
    note = notes.tick
    p note, 0.5, a: fade.look
  end
end

def orchestrate8(note1, note2, note3, note4, ampMod: 1.0)
  in_thread do
    use_synth :saw
    use_synth_defaults amp: 0.85*ampMod, release: 0
    with_fx :hpf, cutoff: 85 do
      with_fx :reverb, mix: 0.5, room: 0.6, amp: 1.05*ampMod do
        play note1, attack: 10, cutoff: 90, pan: -1
        sleep 1
        play note2, attack: 9, cutoff: 90, pan: 1
        sleep 1
        play note3, attack: 8, cutoff: 90, pan: -0.5
        sleep 1
        play note4, attack: 7, cutoff: 90, pan: 0.6, amp: 0.5*ampMod
      end
    end
  end
end

def orchestrate32(note1, note2, note3, note4, ampMod: 1.0)
  in_thread do
    use_synth :saw
    use_synth_defaults amp: 0.85*ampMod, release: 0
    with_fx :hpf, cutoff: 80 do
      with_fx :reverb, mix: 0.4 do
        play note1, attack: 40, cutoff: 90, pan: -1
        sleep 4
        play note2, attack: 35, cutoff: 90, pan: 1
        sleep 4
        play note3, attack: 30, cutoff: 90, pan: -0.5
        sleep 4
        play note4, attack: 25, cutoff: 90, pan: 0.6, amp: 0.5*ampMod
      end
    end
  end
end

# Sound designed LUSH elements

def playLushSounds
  in_thread do
    sleep 2
    with_fx :reverb, room: 0.9, amp: 1.4 do
      with_fx :hpf, cutoff: 80 do
        sample :ambi_glass_hum, attack: 3
        sleep 1
        sample :ambi_glass_hum, attack: 1, rate: 2, amp: 0.7, pan: -0.9
        sample :ambi_glass_hum, attack: 1, rate: -2, amp: 0.7, pan: 0.9
      end
    end
  end
end

def playIntroStingers
  in_thread do
    with_fx :reverb, echo: 0.9 do
      sample :ambi_dark_woosh, rate: -1.5, amp: 2, cutoff: 130
      sleep 5
      sample :ambi_haunted_hum, rate: pitch_to_ratio(4), attack: 4
    end
  end
end

# The actual song start here
tick_reset_all

with_fx :compressor do
  with_fx :reverb, room: 0.1, mix: 0.4 do
    
    # Intro sounds
    
    playIntroStingers
    # playLushSounds
    
    # Percussion in a separate thread
    in_thread do
      with_fx :hpf, cutoff: 60, cutoff_slide: 8, amp: 0, amp_slide: 8 do |c|
        control c, amp: 1
        32.times do
          control c, cutoff: [90, 50].ring.tick
          16.times do
            sample :elec_tick, amp: amp_mod.tick, pan: pan_mod.look, rate: 1.5
            sleep 0.25
          end
        end
      end
    end
    
    # Intro melody notes
    
    4.times do
      playPartWithFade(notes1, fade: introFade)
    end
    
    # 1st melody part
    
    2.times do
      pl :Gb2, 5
      playPart(notes1)
      pl :A2, 5
      playPart(notes1)
      pl :Bb2, 10
      2.times do
        playPart(notes2)
      end
    end
    
    # 2nd melody part
    
    2.times do
      pl :E2, 5
      playPart(notes3)
      pl :G2, 5
      playPart(notes3)
      pl :Eb2, 5
      2.times do
        playPart(notes4)
      end
    end
    
    # 3rd melody part
    
    orchestrate32(:Gb3, :B4, :D4, :G5, ampMod: 0.9)
    
    2.times do
      mod = [0, 0].ring.look
      pl :B1, 5, modulation: mod
      playPart(notes5)
      pl :D2, 5, modulation: mod
      playPart(notes5)
      pl :E2, 5, modulation: mod
      playPart(notes5)
      pl :Gb2, 5, modulation: mod
      playPart(notes5)
    end
    
    with_fx :hpf, cutoff: 60, cutoff_slide: 10 do |fx|
      control fx, cutoff: 100
      2.times do
        playPart(notes5)
      end
      control fx, cutoff: 60
      
      # Rerun the "intro"
      
      3.times do
        playPart(notes1)
      end
      playPart(notes1R)
    end
    
    # Biitz
    in_thread do
      with_fx :bitcrusher, mix: 0.1, amp: 0.8 do
        with_fx :rlpf, cutoff: 130, cutoff_slide: 16, res: 0.9, res_slide: 16 do |slide|
          control slide, cutoff: 70, res: 0.0
          8.times do |z|
            sample :loop_amen_full, hpf: 80, beat_stretch: 16
            4.times do
              at [0, 1.5, 3.5] do sample :bd_zum end
              at [1, 3] do sample :sn_dolf end
              #at [0.5, 1.5, 2.5, 3.5] do sample :drum_cymbal_closed, amp: 0.5 end
              sleep 4
            end
            control slide, res: 0.5 - (z*0.1), cutoff: 80 + ((z+1)*10) if z < 5
            control slide, res: 0.1, cutoff: 50 + (z*10) if z >= 5 && z < 7
            control slide, res: 0.1, cutoff: 50 if z >= 7
          end
        end
      end
    end
    
    2.times do |i|
      orchestrate8(:Gb3, :A4, :Db4, :D5, ampMod: 1.1 + i/5)
      pl :Gb2, 5
      playPart(notes1)
      pl :A2, 5
      playPart(notes1)
      orchestrate8(:C4, :F4, :F3, :Db5, ampMod: 1.1 + i/10)
      pl :Bb2, 10
      2.times do
        playPart(notes2)
      end
    end
    
    # Rerun 2nd melody part
    
    2.times do |i|
      orchestrate8(:E4, :B4, :B5, :E5, ampMod: 1.1 + ((i-1)*0.31))
      pl :E2, 5
      playPart(notes3)
      pl :G2, 5
      playPart(notes3)
      pl :Eb2, 5
      orchestrate8(:Eb4, :Bb4, :Eb3, :Bb5, ampMod: 1.1 + ((i-1)*0.31))
      2.times do
        playPart(notes4)
      end
    end
    
    # Rerun 3rd melody part
    
    orchestrate32(:Gb3, :B4, :D4, :G5, ampMod: 1.2)
    
    2.times do
      pl :B1, 5
      playPart(notes5)
      pl :D2, 5
      playPart(notes5)
      pl :E2, 5
      playPart(notes5)
      pl :Gb2, 5
      playPart(notes5)
    end
    
    2.times do
      playPart(notes5)
    end
    
    # Outro (with fadeout)
    
    4.times do
      playPartWithFade(notes1, fade: outroFade)
    end
  end
end