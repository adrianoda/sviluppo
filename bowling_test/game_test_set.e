note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	GAME_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create game.make
		end

	roll_many(n : INTEGER; pins : INTEGER)
		do
			across 1 |..| n as i loop
				game.roll (pins)
			end
		end

	roll_spare
		do
			roll_many(2, 5)
		end

	roll_strike
		do
			game.roll (10)
		end

feature -- Test routines

	game : GAME

	test_gutter_game
		do
			roll_many(20, 0)
			assert ("expecting score 0", game.score = 0)
		end

	test_all_ones
		do
			roll_many(20, 1)
			assert ("expecting score 20", game.score = 20)
		end

	test_one_spare
		do
			roll_spare
			game.roll (3)
			roll_many(17,0)
			assert ("expecting score 16", game.score = 16)
		end

	test_one_strike
		do
			roll_strike
			game.roll (3)
			game.roll (4)
			roll_many(16, 0)
			assert ("expecting score 24", game.score = 24)
		end

	test_perfect_game
		do
			roll_many(12,10)
			assert ("expecting score 300", game.score = 300)
		end

	test_last_spare
		do
			roll_many(9, 10)
			roll_spare
			game.roll (10)
			assert ("expecting score 275", game.score = 275)
		end

	test_last_strike
		do
			roll_many(18, 1)
			roll_strike
			game.roll (10)
			game.roll (10)
			assert ("expecting score 48", game.score = 48)
		end

end


