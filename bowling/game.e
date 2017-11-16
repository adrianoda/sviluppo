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

	-- score ensure checks
	gutter_game(s : INTEGER) : BOOLEAN
	local
		frame_index : INTEGER
		in_scope : BOOLEAN
	do
		in_scope := TRUE
		across 0 |..| 9 as frame loop
			if is_strike(frame_index) or is_spare(frame_index) or rolls[frame_index] > 0 or rolls[frame_index+1] > 0 then
				-- out of scope
				in_scope := FALSE
			else
				frame_index := frame_index + 2
			end
		end
		Result := in_scope and s = 0
	end

	all_ones(s : INTEGER) : BOOLEAN
	local
		frame_index : INTEGER
		in_scope : BOOLEAN
	do
		in_scope := TRUE
		across 0 |..| 9 as frame loop
			if is_strike(frame_index) or is_spare(frame_index) or rolls[frame_index] /= 1 or rolls[frame_index+1] /= 1 then
				-- out of scope
				in_scope := FALSE
			else
				frame_index := frame_index + 2
			end
		end
		Result := in_scope and s = 20
	end


feature
	make
		do
			create rolls.make_filled (0, 0, 20)
		end

	roll(pins : INTEGER)
		require
			slayed_pins: pins >= 0 and pins <= 10
		do
			rolls[current_roll] := pins
			current_roll := current_roll + 1
		ensure
			current_roll_saved: rolls[current_roll-1] = pins
			number_of_rolls: current_roll > 0 and current_roll <= 20
			next_roll_empty: rolls[current_roll] + pins = pins
			adjacent_roll_value: (rolls[current_roll-1] + pins) <= 20
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
			uncle_bob: gutter_game(Result) or
					   all_ones(Result)
			-- TODO add other checks
		end

end
