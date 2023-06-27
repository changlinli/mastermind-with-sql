-- Need to solicit input from the user
-- Need some way of printing output (to the terminal)
-- The DB will persist state



-- Making a guess: INSERT row of four values
-- "checking the guess": SELECT, is going to repeat a lot of work each time



-- RRBY: guess
-- GRPB: actual answer
-- expected: -bw-







-- 1st step: get exact matches
-- 2nd step: get color stats
-- 3rd step: iterate and decrement according to the state from the previous two steps
--
/*

R
R
B
Y

R,0
R,1
B,2
Y,3

exact_matches:
R, 1

per_color_sum_of_guess_minus_exact:
R, 1
B, 1
Y, 0

per_color_sum_of_answer_minus_exact:
G, 0
R, 0
P, 0
B, 0

one group by gives you number of exact matches
another group by gives you number of per_color sum for guess
another group by gives you number of per_color sum for answer
row-wise subtraction gives you the diff
and then return mastermind-style output



R, "01"
B, "2"
Y, "3"

G, "0"
R, "1"
P, "2"
B, "3"



*/



WITH last_guess AS (
	SELECT 'a' AS color, 0 AS idx
	UNION
	SELECT 'b' AS color, 1 AS idx
	UNION
	SELECT 'c' AS color, 2 AS idx
	UNION
	SELECT 'd' AS color, 3 AS idx
),
actual_answer AS (
	SELECT 'a' AS color, 0 AS idx
	UNION
	SELECT 'b' AS color, 1 AS idx
	UNION
	SELECT 'c' AS color, 2 AS idx
	UNION
	SELECT 'd' AS color, 3 AS idx
),
guess_vs_answer AS (
	SELECT l.color AS guess_color
	, a.color AS answer_color
	FROM last_guess l INNER JOIN actual_answer a ON l.idx = a.idx
),
exact_matches AS (
	SELECT guess_color
	FROM guess_vs_answer WHERE guess_color = answer_color
),
per_color_sum_of_guess_minus_exact AS (
	SELECT guess_color
	, COUNT(CASE WHEN guess_color <> answer_color THEN TRUE END) AS num_of_guess_color
	FROM guess_vs_answer GROUP BY guess_color
),
per_color_sum_of_answer_minus_exact AS (
	SELECT answer_color
	, COUNT(CASE WHEN guess_color <> answer_color THEN TRUE END) AS num_of_answer_color
	FROM guess_vs_answer GROUP BY answer_color
),
per_color_num_of_white_pins AS (
	SELECT MIN(num_of_guess_color, num_of_answer_color) AS num_of_white_pins
	FROM per_color_sum_of_guess_minus_exact 
	INNER JOIN per_color_sum_of_answer_minus_exact ON guess_color = answer_color
),
total_num_of_black_pins AS (
	SELECT COUNT(*) AS total_num_of_black_pins FROM exact_matches
),
total_num_of_white_pins AS (
	SELECT SUM(num_of_white_pins) AS total_num_of_white_pins FROM per_color_num_of_white_pins
),
final_answer AS (
	SELECT printf('%.*c', total_num_of_black_pins, 'x') || printf('%.*c', total_num_of_white_pins, 'x')
	FROM total_num_of_black_pins INNER JOIN total_num_of_white_pins ON TRUE
)
SELECT * FROM final_answer
