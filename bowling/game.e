note
	description: "Summary description for {KATA_BOWLING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

create
	make

feature {NONE}
	rolls : ARRAY[INTEGER]
	current_roll : INTEGER

	is_strike(frame_index : INTEGER) : BOOLEAN
	do
		Result := rolls[frame_index] = 10
	end

	is_spare(frame_index : INTEGER) : BOOLEAN
	do
		Result := rolls[frame_index] + rolls[frame_index + 1] = 10
	end

	sum_of_balls_in_frame(frame_index : INTEGER) : INTEGER
	do
		Result := rolls[frame_index] + rolls[frame_index + 1]
	end

	spare_bonus(frame_index : INTEGER) : INTEGER
	do
		Result := rolls[frame_index + 2]
	end

	strike_bonus(frame_index : INTEGER) : INTEGER
	do
		Result := rolls[frame_index + 1] + rolls[frame_index + 2]
	end


feature
	make
		do
			create rolls.make_filled (0, 0, 21)
		end

	roll(pins : INTEGER)
		require
			pins_number_not_exceeded: pins >= 0 and pins <= 10
		do
			rolls[current_roll] := pins
			current_roll := current_roll + 1
		ensure
			rolls_increased: current_roll = old current_roll + 1
			rolls_not_exceeded: current_roll <= 21
			current_roll_saved: rolls[old current_roll] = pins
			next_roll_empty: rolls[current_roll] + pins = pins
		end

	score : INTEGER
		local
			frame_index : INTEGER
			s : INTEGER
		do
			across 0 |..| 9 as frame loop
				if is_strike(frame_index) then
					s := s + 10 + strike_bonus(frame_index)
					frame_index := frame_index + 1
				elseif is_spare(frame_index) then
					s := s + 10 + spare_bonus(frame_index)
					frame_index := frame_index + 2
				else
					s := s + sum_of_balls_in_frame(frame_index)
					frame_index := frame_index + 2
				end
			end
			print("Score " + s.out + "%N")
			Result := s
		ensure
			positive_score: Result >= 0
			score_not_exeeded: Result <= 300
			score_value: Result = pins_score + bonus_score
		end

	pins_score : INTEGER
		local
			s : INTEGER
			frame_index : INTEGER
			frame_len : INTEGER
		do
			frame_len := 19
			from frame_index := 0
			until
				frame_index > frame_len
			loop
				s := s + rolls[frame_index]
				if rolls[frame_index] = 10 then
					frame_len := frame_len -1
				end
				frame_index := frame_index + 1
			end
			Result := s
		end

	bonus_score : INTEGER
		local
			s : INTEGER
			frame_index : INTEGER
			frame_len : INTEGER
		do
			frame_len := 19
			from frame_index := 0
			until
				frame_index > frame_len
			loop
				-- Strike bonux
				if rolls[frame_index] = 10 then
					s := s + rolls[frame_index + 1] + rolls[frame_index + 2]
					frame_len := frame_len -1
				-- Spare bonux
				elseif (rolls[frame_index] + rolls[frame_index + 1]) = 10 then
					s := s + rolls[frame_index + 2]
				end
				frame_index := frame_index + 1
			end
			Result := s
		end

end
