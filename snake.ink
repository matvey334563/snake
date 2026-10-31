// ============================================================
//  ЗМЕЙКА И ЯБЛОКИ — текстовая версия на языке Ink (inkle)
//  Поле 6×6, цель — съесть 10 яблок.
//
//  Запуск:  inklecate.exe snake.ink
//  В браузере: ink.html (компилируется в snake.json)
// ============================================================

VAR score = 0          // съедено яблок
VAR goal = 10          // нужно для победы
VAR turns = 0          // сделано ходов
VAR len = 1            // длина змейки (макс. 5)
VAR head_x = 3         // голова, 0..5
VAR head_y = 3
VAR apple_x = 0        // яблоко
VAR apple_y = 1
VAR apple_n = 1        // номер позиции яблока (1..8)
VAR alive = true
VAR won = false
VAR prev_x = 0         // куда была голова до хода
VAR prev_y = 0

// сегменты тела (b1 — ближе всего к голове)
VAR b1x = -1
VAR b1y = -1
VAR b2x = -1
VAR b2y = -1
VAR b3x = -1
VAR b3y = -1
VAR b4x = -1
VAR b4y = -1
VAR b5x = -1
VAR b5y = -1

// направление: none, up, down, left, right
LIST dirs = none, up, down, left, right
VAR dir = none

=== start ===
Ты — змейка на поле 6×6.
Координаты углов: (0,0) сверху слева, (5,5) снизу справа.
Съешь {goal} яблок, не врезавшись в стену и в себя.

+ Идти -> field
+ Правила -> rules

=== rules ===
Каждый ход ты выбираешь направление.
Нельзя развернуться на 180° (например, идти влево, если идёшь вправо).
За стеной — смерть. За тело — тоже.
Яблоко даёт +1 очко и +1 сегмент тела (но не длиннее 5).
Чем меньше ходов на {goal} яблок — тем лучше результат.

+ Назад -> start

=== field ===
{not alive: -> dead}
{won: -> victory}

~ turns = turns + 1

Ход {turns}, очки {score}/{goal}, длина {len}
Голова ({head_x},{head_y}), яблоко ({apple_x},{apple_y})

* Вверх (if dir != down) -> move_up
* Вниз (if dir != up) -> move_down
* Влево (if dir != right) -> move_left
* Вправо (if dir != left) -> move_right

// ---------- ходы ----------

=== move_up ===
~ prev_x = head_x
~ prev_y = head_y
~ dir = up
~ head_y = head_y - 1
-> check

=== move_down ===
~ prev_x = head_x
~ prev_y = head_y
~ dir = down
~ head_y = head_y + 1
-> check

=== move_left ===
~ prev_x = head_x
~ prev_y = head_y
~ dir = left
~ head_x = head_x - 1
-> check

=== move_right ===
~ prev_x = head_x
~ prev_y = head_y
~ dir = right
~ head_x = head_x + 1
-> check

// ---------- проверки ----------

=== check ===
{head_x < 0 or head_x > 5 or head_y < 0 or head_y > 5:
    ~ alive = false
    -> field
}
{len >= 1 and head_x == b1x and head_y == b1y:
    ~ alive = false
    -> field
}
{len >= 2 and head_x == b2x and head_y == b2y:
    ~ alive = false
    -> field
}
{len >= 3 and head_x == b3x and head_y == b3y:
    ~ alive = false
    -> field
}
{len >= 4 and head_x == b4x and head_y == b4y:
    ~ alive = false
    -> field
}
{len >= 5 and head_x == b5x and head_y == b5y:
    ~ alive = false
    -> field
}

// тело сдвигается вниз по цепочке, голова встаёт на новое место
~ b5x = b4x
~ b5y = b4y
~ b4x = b3x
~ b4y = b3y
~ b3x = b2x
~ b3y = b2y
~ b2x = b1x
~ b2y = b1y
~ b1x = prev_x
~ b1y = prev_y

{head_x == apple_x and head_y == apple_y:
    -> eat
}
-> field

// ---------- яблоко ----------

=== eat ===
~ score = score + 1
{len < 5:
    ~ len = len + 1
}
Яблоко съедено! Всего очков: {score}.
{score >= goal:
    ~ won = true
    -> field
}
-> next_apple

=== next_apple ===
~ apple_n = apple_n + 1
{apple_n > 8:
    ~ apple_n = 1
}
{apple_n == 1: -> place_1}
{apple_n == 2: -> place_2}
{apple_n == 3: -> place_3}
{apple_n == 4: -> place_4}
{apple_n == 5: -> place_5}
{apple_n == 6: -> place_6}
{apple_n == 7: -> place_7}
{apple_n == 8: -> place_8}
-> place_1

=== place_1 ===
~ apple_x = 0
~ apple_y = 4
-> check_apple

=== place_2 ===
~ apple_x = 5
~ apple_y = 0
-> check_apple

=== place_3 ===
~ apple_x = 2
~ apple_y = 5
-> check_apple

=== place_4 ===
~ apple_x = 4
~ apple_y = 3
-> check_apple

=== place_5 ===
~ apple_x = 1
~ apple_y = 1
-> check_apple

=== place_6 ===
~ apple_x = 5
~ apple_y = 4
-> check_apple

=== place_7 ===
~ apple_x = 3
~ apple_y = 0
-> check_apple

=== place_8 ===
~ apple_x = 0
~ apple_y = 2
-> check_apple

// если яблоко легло под тело — сдвигаем его на клетку вниз
=== check_apple ===
{(head_x == apple_x and head_y == apple_y) or (b1x == apple_x and b1y == apple_y and len >= 1) or (b2x == apple_x and b2y == apple_y and len >= 2) or (b3x == apple_x and b3y == apple_y and len >= 3) or (b4x == apple_x and b4y == apple_y and len >= 4) or (b5x == apple_x and b5y == apple_y and len >= 5):
    ~ apple_y = apple_y + 1
    {apple_y > 5:
        ~ apple_y = 0
        ~ apple_x = apple_x + 1
    }
    {apple_x > 5:
        ~ apple_x = 0
    }
    -> check_apple
}
-> field

// ---------- концовки ----------

=== dead ===
Змейка {head_x},{head_y} — и ты врезался {if dir == up:в потолок|{if dir == down:в пол|{if dir == left:в левую стену|в правую стену}}}.

Ходов сделано: {turns}. Яблок съедено: {score} из {goal}.

+ Попробовать ещё раз -> restart
+ Выход -> bye

=== victory ===
Победа! Ты съел {goal} яблок за {turns} ходов.
{turns <= 20: Это отличный результат! |{turns <= 35: Хорошо, но можно быстрее.|Ну, ты добрался.}}

+ Сыграть ещё -> restart
+ Выход -> bye

=== restart ===
// полный сброс состояния
~ score = 0
~ turns = 0
~ len = 1
~ head_x = 3
~ head_y = 3
~ apple_x = 0
~ apple_y = 1
~ apple_n = 1
~ alive = true
~ won = false
~ prev_x = 0
~ prev_y = 0
~ b1x = -1
~ b1y = -1
~ b2x = -1
~ b2y = -1
~ b3x = -1
~ b3y = -1
~ b4x = -1
~ b4y = -1
~ b5x = -1
~ b5y = -1
~ dir = none
Давай заново.
-> field

=== bye ===
Заходи ещё.
-> DONE
