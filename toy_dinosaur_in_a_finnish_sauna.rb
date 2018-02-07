# Test-driving the new Mehackit
# samples by making some beats

# First, we begin the story with our
# little TOY DINO in a Finnish sauna!

use_bpm 122

with_fx :reverb, room: 0.3, mix: 0.7 do
  sample :mehackit_robot6, rate: 0.5, amp: 1.2, start: 0.4, attack: 0.2
  sleep 2
  sample :mehackit_robot1, start: 0.0, attack: 0.25, cutoff: 120, rate: 0.75, amp: 2
  sleep 1
  sample :mehackit_robot3, cutoff: 120
  sleep 4
  sample :mehackit_robot2, cutoff: 120
  sleep 2
end

with_fx :reverb, room: 0.9 do
  sample :ambi_sauna, amp: 0.85
  sleep 4
  
  with_fx :reverb, room: 0.2, mix: 0.65 do
    sample :mehackit_robot5, rate: -0.5, amp: 2
    sleep 6
  end
end

4.times do |i|
  
  in_thread do
    8.times do
      if i >= 3
        hipass = 70
      else
        hipass = 0
      end
      sample :bd_mehackit, amp: 1.5, hpf: hipass
      sleep 1
    end
  end
  
  with_fx :reverb, room: 0.4, mix: 0.6 do
    in_thread do
      with_fx :lpf, res: 0.7, cutoff: 130, cutoff_slide: 8 do |c|
        if i == 3
          control c, cutoff: 50
        end
        with_fx :distortion, amp: 0.7 do
          sample :glitch_bass_g, rate: -1, amp: 1.9
        end
        2.times do
          sleep 3
          sample [:glitch_perc1, :glitch_perc2, :glitch_perc3, :glitch_perc4, :glitch_perc5].choose, rate: rrand(0.8, 1.2)*[1,1,-1].choose
          sleep 0.5
          sample [:glitch_perc1, :glitch_perc2, :glitch_perc3, :glitch_perc4, :glitch_perc5].choose, rate: rrand(0.8, 1.2)*[1,1,-1].choose
          sleep 0.5
        end
      end
    end
  end
  
  in_thread do
    with_fx :lpf, res: 0.7, cutoff: 130, cutoff_slide: 8 do |c|
      if i == 3
        control c, cutoff: 50
      end
      with_fx :panslicer, wave: 2, phase: 2.5, mix: 0.4 do
        32.times do
          sample [:loop_mehackit1, :loop_mehackit2].choose, beat_stretch: 4, rate: [1,1,1,1,-1,1.5].choose, amp: 1, slice: pick, sustain: 0, release: 0.2
          sleep 0.25
        end
      end
    end
  end
  
  in_thread do
    with_fx :lpf, res: 0.7, cutoff: 130, cutoff_slide: 8 do |c|
      if i == 3
        control c, cutoff: 50
      end
      2.times do
        sample [:mehackit_phone1, :mehackit_phone2, :mehackit_phone3, :mehackit_phone4, :mehackit_phone5].choose, rate: rrand(0.8, 1.2)*[1,1,-1].choose
        sleep 1.5
      end
      sleep 1.0
      2.times do
        sample [:mehackit_robot1, :mehackit_robot2, :mehackit_robot3, :mehackit_robot4].choose, rate: rrand(0.8, 1.2)*[1,1,-1].choose
        sleep 1.5
      end
      sleep 0.5
    end
  end
  
  if i == 3
    with_fx :reverb, room: 0.99 do
      sample :loop_3d_printer, amp: 2.6, rate: -1, attack: 8, beat_stretch: 8, hpf: 50
    end
  end
  sleep 8
  sample :perc_impact1
end

sleep 1
with_fx :reverb, room: 0.99 do
  sample :perc_bell2, hpf: 60
  sample :perc_impact1, rate: -0.7, amp: 2
end
sleep 3

4.times do |i|
  
  with_fx :reverb, room: 0.65 do
    with_fx :distortion, distort: 0.9, amp: 0.325 do
      in_thread do
        if i < 2
          bassroot = :G1
        else
          bassroot = :A1
        end
        h = synth :chipbass, note: bassroot, note_slide: 16, cutoff: 60, cutoff_slide: 4, attack: 2, sustain: 4, release: 0.1
        sleep 1
        control h, note: bassroot+48, cutoff: 130
        control h, cutoff: 130
        sleep 5
        2.times do
          s = synth :pulse, note: bassroot, note_slide: 2, cutoff: 60, cutoff_slide: 2, sustain: 1, release: 0.1
          control s, note: bassroot+60, cutoff: 130
          sleep 1
        end
      end
    end
  end
  
  in_thread do
    8.times do
      if i >= 3
        hipass = 70
      else
        hipass = 0
      end
      sample :bd_mehackit, amp: 1.5, hpf: hipass
      sleep 1
    end
  end
  
  in_thread do
    with_fx :reverb do
      4.times do
        sleep 1
        sample :sn_generic
        sample :perc_swoosh, amp: 1.5
        sleep 1
      end
    end
  end
  
  in_thread do
    with_fx :bitcrusher, mix: 0.5, bits: 16, bits_slide: 8 do |z|
      control z, bits: 1 if i == 3
      sample :loop_weirdo, beat_stretch: 8, amp: [0, 0.35, 0.7, 1.1][i]
      sleep 8
    end
  end
  
  
  in_thread do
    with_fx :lpf, res: 0.7, cutoff: 130, cutoff_slide: 8 do |x|
      control x, cutoff: 20 if i == 3
      2.times do
        sample :loop_electric, beat_stretch: 4, amp: [1, 1.1, 1.2, 1.3][i]
        sleep 4
      end
    end
  end
  
  if i == 3
    with_fx :reverb, room: 0.99 do
      sample :loop_electric, amp: 3, rate: -1, attack: 8, beat_stretch: 8, hpf: 50
    end
  end
  sleep 8
end

#YEAH!!!
