from fuzzywuzzy import fuzz
import Levenshtein as lev

list_MC = [ "Proportionalgain", 10,
         "Integralgain", 0.5,
         "Derivativegain", 0,
         "Bool", False]


list_New = [ "Igain", 2,
         "Dgain", 3,
         "Pgain", 1,
         "Boolean", True]

size = len(list_MC)
k = 1
old_fuzzy_state = 0
old_state = 0



for i in range(size):
    if type(list_MC[i]) == str:
        for j in range(size):
            if type(list_New[j]) == str:
                new_fuzzy_state = fuzz.ratio(list_MC[i], list_New[j])
                new_state = int(lev.ratio(list_MC[i], list_New[j])*100)
                if new_fuzzy_state >= old_fuzzy_state and new_state >= old_state:
                    old_fuzzy_state = new_fuzzy_state
                    old_state = new_state
                    k = j
                else:
                    continue
            else:
                continue
        list_MC[i+1] = list_New[k+1]
        old_fuzzy_state = 0
        old_state = 0
    else:
        continue

print(list_MC)