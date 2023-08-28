var n="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var r={};
/**
 * @typedef {string | ((unitCount: number) => string)} Unit
 */
/**
 * @typedef {("y" | "mo" | "w" | "d" | "h" | "m" | "s" | "ms")} UnitName
 */
/**
 * @typedef {Object} UnitMeasures
 * @prop {number} y
 * @prop {number} mo
 * @prop {number} w
 * @prop {number} d
 * @prop {number} h
 * @prop {number} m
 * @prop {number} s
 * @prop {number} ms
 */
/**
 * @typedef {Record<"0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9", string>} DigitReplacements
 */
/**
 * @typedef {Object} Language
 * @prop {Unit} y
 * @prop {Unit} mo
 * @prop {Unit} w
 * @prop {Unit} d
 * @prop {Unit} h
 * @prop {Unit} m
 * @prop {Unit} s
 * @prop {Unit} ms
 * @prop {string} [decimal]
 * @prop {string} [delimiter]
 * @prop {DigitReplacements} [_digitReplacements]
 * @prop {boolean} [_numberFirst]
 */
/**
 * @typedef {Object} Options
 * @prop {string} [language]
 * @prop {Record<string, Language>} [languages]
 * @prop {string[]} [fallbacks]
 * @prop {string} [delimiter]
 * @prop {string} [spacer]
 * @prop {boolean} [round]
 * @prop {number} [largest]
 * @prop {UnitName[]} [units]
 * @prop {string} [decimal]
 * @prop {string} [conjunction]
 * @prop {number} [maxDecimalPoints]
 * @prop {UnitMeasures} [unitMeasures]
 * @prop {boolean} [serialComma]
 * @prop {DigitReplacements} [digitReplacements]
 */
/**
 * @typedef {Required<Options>} NormalizedOptions
 */(function(){var t=language((function(n){return 1===n?"χρόνος":"χρόνια"}),(function(n){return 1===n?"μήνας":"μήνες"}),(function(n){return 1===n?"εβδομάδα":"εβδομάδες"}),(function(n){return 1===n?"μέρα":"μέρες"}),(function(n){return 1===n?"ώρα":"ώρες"}),(function(n){return 1===n?"λεπτό":"λεπτά"}),(function(n){return 1===n?"δευτερόλεπτο":"δευτερόλεπτα"}),(function(n){return(1===n?"χιλιοστό":"χιλιοστά")+" του δευτερολέπτου"}),",");
/** @type {Record<string, Language>} */var u={af:language("jaar",(function(n){return"maand"+(1===n?"":"e")}),(function(n){return 1===n?"week":"weke"}),(function(n){return 1===n?"dag":"dae"}),(function(n){return 1===n?"uur":"ure"}),(function(n){return 1===n?"minuut":"minute"}),(function(n){return"sekonde"+(1===n?"":"s")}),(function(n){return"millisekonde"+(1===n?"":"s")}),","),ar:assign(language((function(n){return["سنة","سنتان","سنوات"][getArabicForm(n)]}),(function(n){return["شهر","شهران","أشهر"][getArabicForm(n)]}),(function(n){return["أسبوع","أسبوعين","أسابيع"][getArabicForm(n)]}),(function(n){return["يوم","يومين","أيام"][getArabicForm(n)]}),(function(n){return["ساعة","ساعتين","ساعات"][getArabicForm(n)]}),(function(n){return["دقيقة","دقيقتان","دقائق"][getArabicForm(n)]}),(function(n){return["ثانية","ثانيتان","ثواني"][getArabicForm(n)]}),(function(n){return["جزء من الثانية","جزآن من الثانية","أجزاء من الثانية"][getArabicForm(n)]}),","),{delimiter:" ﻭ ",_digitReplacements:["۰","١","٢","٣","٤","٥","٦","٧","٨","٩"]}),bg:language((function(n){return["години","година","години"][getSlavicForm(n)]}),(function(n){return["месеца","месец","месеца"][getSlavicForm(n)]}),(function(n){return["седмици","седмица","седмици"][getSlavicForm(n)]}),(function(n){return["дни","ден","дни"][getSlavicForm(n)]}),(function(n){return["часа","час","часа"][getSlavicForm(n)]}),(function(n){return["минути","минута","минути"][getSlavicForm(n)]}),(function(n){return["секунди","секунда","секунди"][getSlavicForm(n)]}),(function(n){return["милисекунди","милисекунда","милисекунди"][getSlavicForm(n)]}),","),bn:language("বছর","মাস","সপ্তাহ","দিন","ঘন্টা","মিনিট","সেকেন্ড","মিলিসেকেন্ড"),ca:language((function(n){return"any"+(1===n?"":"s")}),(function(n){return"mes"+(1===n?"":"os")}),(function(n){return"setman"+(1===n?"a":"es")}),(function(n){return"di"+(1===n?"a":"es")}),(function(n){return"hor"+(1===n?"a":"es")}),(function(n){return"minut"+(1===n?"":"s")}),(function(n){return"segon"+(1===n?"":"s")}),(function(n){return"milisegon"+(1===n?"":"s")}),","),cs:language((function(n){return["rok","roku","roky","let"][getCzechOrSlovakForm(n)]}),(function(n){return["měsíc","měsíce","měsíce","měsíců"][getCzechOrSlovakForm(n)]}),(function(n){return["týden","týdne","týdny","týdnů"][getCzechOrSlovakForm(n)]}),(function(n){return["den","dne","dny","dní"][getCzechOrSlovakForm(n)]}),(function(n){return["hodina","hodiny","hodiny","hodin"][getCzechOrSlovakForm(n)]}),(function(n){return["minuta","minuty","minuty","minut"][getCzechOrSlovakForm(n)]}),(function(n){return["sekunda","sekundy","sekundy","sekund"][getCzechOrSlovakForm(n)]}),(function(n){return["milisekunda","milisekundy","milisekundy","milisekund"][getCzechOrSlovakForm(n)]}),","),cy:language("flwyddyn","mis","wythnos","diwrnod","awr","munud","eiliad","milieiliad"),da:language("år",(function(n){return"måned"+(1===n?"":"er")}),(function(n){return"uge"+(1===n?"":"r")}),(function(n){return"dag"+(1===n?"":"e")}),(function(n){return"time"+(1===n?"":"r")}),(function(n){return"minut"+(1===n?"":"ter")}),(function(n){return"sekund"+(1===n?"":"er")}),(function(n){return"millisekund"+(1===n?"":"er")}),","),de:language((function(n){return"Jahr"+(1===n?"":"e")}),(function(n){return"Monat"+(1===n?"":"e")}),(function(n){return"Woche"+(1===n?"":"n")}),(function(n){return"Tag"+(1===n?"":"e")}),(function(n){return"Stunde"+(1===n?"":"n")}),(function(n){return"Minute"+(1===n?"":"n")}),(function(n){return"Sekunde"+(1===n?"":"n")}),(function(n){return"Millisekunde"+(1===n?"":"n")}),","),el:t,en:language((function(n){return"year"+(1===n?"":"s")}),(function(n){return"month"+(1===n?"":"s")}),(function(n){return"week"+(1===n?"":"s")}),(function(n){return"day"+(1===n?"":"s")}),(function(n){return"hour"+(1===n?"":"s")}),(function(n){return"minute"+(1===n?"":"s")}),(function(n){return"second"+(1===n?"":"s")}),(function(n){return"millisecond"+(1===n?"":"s")})),eo:language((function(n){return"jaro"+(1===n?"":"j")}),(function(n){return"monato"+(1===n?"":"j")}),(function(n){return"semajno"+(1===n?"":"j")}),(function(n){return"tago"+(1===n?"":"j")}),(function(n){return"horo"+(1===n?"":"j")}),(function(n){return"minuto"+(1===n?"":"j")}),(function(n){return"sekundo"+(1===n?"":"j")}),(function(n){return"milisekundo"+(1===n?"":"j")}),","),es:language((function(n){return"año"+(1===n?"":"s")}),(function(n){return"mes"+(1===n?"":"es")}),(function(n){return"semana"+(1===n?"":"s")}),(function(n){return"día"+(1===n?"":"s")}),(function(n){return"hora"+(1===n?"":"s")}),(function(n){return"minuto"+(1===n?"":"s")}),(function(n){return"segundo"+(1===n?"":"s")}),(function(n){return"milisegundo"+(1===n?"":"s")}),","),et:language((function(n){return"aasta"+(1===n?"":"t")}),(function(n){return"kuu"+(1===n?"":"d")}),(function(n){return"nädal"+(1===n?"":"at")}),(function(n){return"päev"+(1===n?"":"a")}),(function(n){return"tund"+(1===n?"":"i")}),(function(n){return"minut"+(1===n?"":"it")}),(function(n){return"sekund"+(1===n?"":"it")}),(function(n){return"millisekund"+(1===n?"":"it")}),","),eu:language("urte","hilabete","aste","egun","ordu","minutu","segundo","milisegundo",","),fa:language("سال","ماه","هفته","روز","ساعت","دقیقه","ثانیه","میلی ثانیه"),fi:language((function(n){return 1===n?"vuosi":"vuotta"}),(function(n){return 1===n?"kuukausi":"kuukautta"}),(function(n){return"viikko"+(1===n?"":"a")}),(function(n){return"päivä"+(1===n?"":"ä")}),(function(n){return"tunti"+(1===n?"":"a")}),(function(n){return"minuutti"+(1===n?"":"a")}),(function(n){return"sekunti"+(1===n?"":"a")}),(function(n){return"millisekunti"+(1===n?"":"a")}),","),fo:language("ár",(function(n){return 1===n?"mánaður":"mánaðir"}),(function(n){return 1===n?"vika":"vikur"}),(function(n){return 1===n?"dagur":"dagar"}),(function(n){return 1===n?"tími":"tímar"}),(function(n){return 1===n?"minuttur":"minuttir"}),"sekund","millisekund",","),fr:language((function(n){return"an"+(n>=2?"s":"")}),"mois",(function(n){return"semaine"+(n>=2?"s":"")}),(function(n){return"jour"+(n>=2?"s":"")}),(function(n){return"heure"+(n>=2?"s":"")}),(function(n){return"minute"+(n>=2?"s":"")}),(function(n){return"seconde"+(n>=2?"s":"")}),(function(n){return"milliseconde"+(n>=2?"s":"")}),","),gr:t,he:language((function(n){return 1===n?"שנה":"שנים"}),(function(n){return 1===n?"חודש":"חודשים"}),(function(n){return 1===n?"שבוע":"שבועות"}),(function(n){return 1===n?"יום":"ימים"}),(function(n){return 1===n?"שעה":"שעות"}),(function(n){return 1===n?"דקה":"דקות"}),(function(n){return 1===n?"שניה":"שניות"}),(function(n){return 1===n?"מילישנייה":"מילישניות"})),hr:language((function(n){return n%10===2||n%10===3||n%10===4?"godine":"godina"}),(function(n){return 1===n?"mjesec":2===n||3===n||4===n?"mjeseca":"mjeseci"}),(function(n){return n%10===1&&11!==n?"tjedan":"tjedna"}),(function(n){return 1===n?"dan":"dana"}),(function(n){return 1===n?"sat":2===n||3===n||4===n?"sata":"sati"}),(function(n){var r=n%10;return 2!==r&&3!==r&&4!==r||!(n<10||n>14)?"minuta":"minute"}),(function(n){var r=n%10;return 5===r||Math.floor(n)===n&&n>=10&&n<=19?"sekundi":1===r?"sekunda":2===r||3===r||4===r?"sekunde":"sekundi"}),(function(n){return 1===n?"milisekunda":n%10===2||n%10===3||n%10===4?"milisekunde":"milisekundi"}),","),hi:language("साल",(function(n){return 1===n?"महीना":"महीने"}),(function(n){return 1===n?"हफ़्ता":"हफ्ते"}),"दिन",(function(n){return 1===n?"घंटा":"घंटे"}),"मिनट","सेकंड","मिलीसेकंड"),hu:language("év","hónap","hét","nap","óra","perc","másodperc","ezredmásodperc",","),id:language("tahun","bulan","minggu","hari","jam","menit","detik","milidetik"),is:language("ár",(function(n){return"mánuð"+(1===n?"ur":"ir")}),(function(n){return"vik"+(1===n?"a":"ur")}),(function(n){return"dag"+(1===n?"ur":"ar")}),(function(n){return"klukkutím"+(1===n?"i":"ar")}),(function(n){return"mínút"+(1===n?"a":"ur")}),(function(n){return"sekúnd"+(1===n?"a":"ur")}),(function(n){return"millisekúnd"+(1===n?"a":"ur")})),it:language((function(n){return"ann"+(1===n?"o":"i")}),(function(n){return"mes"+(1===n?"e":"i")}),(function(n){return"settiman"+(1===n?"a":"e")}),(function(n){return"giorn"+(1===n?"o":"i")}),(function(n){return"or"+(1===n?"a":"e")}),(function(n){return"minut"+(1===n?"o":"i")}),(function(n){return"second"+(1===n?"o":"i")}),(function(n){return"millisecond"+(1===n?"o":"i")}),","),ja:language("年","ヶ月","週","日","時間","分","秒","ミリ秒"),km:language("ឆ្នាំ","ខែ","សប្តាហ៍","ថ្ងៃ","ម៉ោង","នាទី","វិនាទី","មិល្លីវិនាទី"),kn:language((function(n){return 1===n?"ವರ್ಷ":"ವರ್ಷಗಳು"}),(function(n){return 1===n?"ತಿಂಗಳು":"ತಿಂಗಳುಗಳು"}),(function(n){return 1===n?"ವಾರ":"ವಾರಗಳು"}),(function(n){return 1===n?"ದಿನ":"ದಿನಗಳು"}),(function(n){return 1===n?"ಗಂಟೆ":"ಗಂಟೆಗಳು"}),(function(n){return 1===n?"ನಿಮಿಷ":"ನಿಮಿಷಗಳು"}),(function(n){return 1===n?"ಸೆಕೆಂಡ್":"ಸೆಕೆಂಡುಗಳು"}),(function(n){return 1===n?"ಮಿಲಿಸೆಕೆಂಡ್":"ಮಿಲಿಸೆಕೆಂಡುಗಳು"})),ko:language("년","개월","주일","일","시간","분","초","밀리 초"),ku:language("sal","meh","hefte","roj","seet","deqe","saniye","mîlîçirk",","),lo:language("ປີ","ເດືອນ","ອາທິດ","ມື້","ຊົ່ວໂມງ","ນາທີ","ວິນາທີ","ມິນລິວິນາທີ",","),lt:language((function(n){return n%10===0||n%100>=10&&n%100<=20?"metų":"metai"}),(function(n){return["mėnuo","mėnesiai","mėnesių"][getLithuanianForm(n)]}),(function(n){return["savaitė","savaitės","savaičių"][getLithuanianForm(n)]}),(function(n){return["diena","dienos","dienų"][getLithuanianForm(n)]}),(function(n){return["valanda","valandos","valandų"][getLithuanianForm(n)]}),(function(n){return["minutė","minutės","minučių"][getLithuanianForm(n)]}),(function(n){return["sekundė","sekundės","sekundžių"][getLithuanianForm(n)]}),(function(n){return["milisekundė","milisekundės","milisekundžių"][getLithuanianForm(n)]}),","),lv:language((function(n){return getLatvianForm(n)?"gads":"gadi"}),(function(n){return getLatvianForm(n)?"mēnesis":"mēneši"}),(function(n){return getLatvianForm(n)?"nedēļa":"nedēļas"}),(function(n){return getLatvianForm(n)?"diena":"dienas"}),(function(n){return getLatvianForm(n)?"stunda":"stundas"}),(function(n){return getLatvianForm(n)?"minūte":"minūtes"}),(function(n){return getLatvianForm(n)?"sekunde":"sekundes"}),(function(n){return getLatvianForm(n)?"milisekunde":"milisekundes"}),","),mk:language((function(n){return 1===n?"година":"години"}),(function(n){return 1===n?"месец":"месеци"}),(function(n){return 1===n?"недела":"недели"}),(function(n){return 1===n?"ден":"дена"}),(function(n){return 1===n?"час":"часа"}),(function(n){return 1===n?"минута":"минути"}),(function(n){return 1===n?"секунда":"секунди"}),(function(n){return 1===n?"милисекунда":"милисекунди"}),","),mn:language("жил","сар","долоо хоног","өдөр","цаг","минут","секунд","миллисекунд"),mr:language((function(n){return 1===n?"वर्ष":"वर्षे"}),(function(n){return 1===n?"महिना":"महिने"}),(function(n){return 1===n?"आठवडा":"आठवडे"}),"दिवस","तास",(function(n){return 1===n?"मिनिट":"मिनिटे"}),"सेकंद","मिलिसेकंद"),ms:language("tahun","bulan","minggu","hari","jam","minit","saat","milisaat"),nl:language("jaar",(function(n){return 1===n?"maand":"maanden"}),(function(n){return 1===n?"week":"weken"}),(function(n){return 1===n?"dag":"dagen"}),"uur",(function(n){return 1===n?"minuut":"minuten"}),(function(n){return 1===n?"seconde":"seconden"}),(function(n){return 1===n?"milliseconde":"milliseconden"}),","),no:language("år",(function(n){return"måned"+(1===n?"":"er")}),(function(n){return"uke"+(1===n?"":"r")}),(function(n){return"dag"+(1===n?"":"er")}),(function(n){return"time"+(1===n?"":"r")}),(function(n){return"minutt"+(1===n?"":"er")}),(function(n){return"sekund"+(1===n?"":"er")}),(function(n){return"millisekund"+(1===n?"":"er")}),","),pl:language((function(n){return["rok","roku","lata","lat"][getPolishForm(n)]}),(function(n){return["miesiąc","miesiąca","miesiące","miesięcy"][getPolishForm(n)]}),(function(n){return["tydzień","tygodnia","tygodnie","tygodni"][getPolishForm(n)]}),(function(n){return["dzień","dnia","dni","dni"][getPolishForm(n)]}),(function(n){return["godzina","godziny","godziny","godzin"][getPolishForm(n)]}),(function(n){return["minuta","minuty","minuty","minut"][getPolishForm(n)]}),(function(n){return["sekunda","sekundy","sekundy","sekund"][getPolishForm(n)]}),(function(n){return["milisekunda","milisekundy","milisekundy","milisekund"][getPolishForm(n)]}),","),pt:language((function(n){return"ano"+(1===n?"":"s")}),(function(n){return 1===n?"mês":"meses"}),(function(n){return"semana"+(1===n?"":"s")}),(function(n){return"dia"+(1===n?"":"s")}),(function(n){return"hora"+(1===n?"":"s")}),(function(n){return"minuto"+(1===n?"":"s")}),(function(n){return"segundo"+(1===n?"":"s")}),(function(n){return"milissegundo"+(1===n?"":"s")}),","),ro:language((function(n){return 1===n?"an":"ani"}),(function(n){return 1===n?"lună":"luni"}),(function(n){return 1===n?"săptămână":"săptămâni"}),(function(n){return 1===n?"zi":"zile"}),(function(n){return 1===n?"oră":"ore"}),(function(n){return 1===n?"minut":"minute"}),(function(n){return 1===n?"secundă":"secunde"}),(function(n){return 1===n?"milisecundă":"milisecunde"}),","),ru:language((function(n){return["лет","год","года"][getSlavicForm(n)]}),(function(n){return["месяцев","месяц","месяца"][getSlavicForm(n)]}),(function(n){return["недель","неделя","недели"][getSlavicForm(n)]}),(function(n){return["дней","день","дня"][getSlavicForm(n)]}),(function(n){return["часов","час","часа"][getSlavicForm(n)]}),(function(n){return["минут","минута","минуты"][getSlavicForm(n)]}),(function(n){return["секунд","секунда","секунды"][getSlavicForm(n)]}),(function(n){return["миллисекунд","миллисекунда","миллисекунды"][getSlavicForm(n)]}),","),sq:language((function(n){return 1===n?"vit":"vjet"}),"muaj","javë","ditë","orë",(function(n){return"minut"+(1===n?"ë":"a")}),(function(n){return"sekond"+(1===n?"ë":"a")}),(function(n){return"milisekond"+(1===n?"ë":"a")}),","),sr:language((function(n){return["години","година","године"][getSlavicForm(n)]}),(function(n){return["месеци","месец","месеца"][getSlavicForm(n)]}),(function(n){return["недељи","недеља","недеље"][getSlavicForm(n)]}),(function(n){return["дани","дан","дана"][getSlavicForm(n)]}),(function(n){return["сати","сат","сата"][getSlavicForm(n)]}),(function(n){return["минута","минут","минута"][getSlavicForm(n)]}),(function(n){return["секунди","секунда","секунде"][getSlavicForm(n)]}),(function(n){return["милисекунди","милисекунда","милисекунде"][getSlavicForm(n)]}),","),ta:language((function(n){return 1===n?"வருடம்":"ஆண்டுகள்"}),(function(n){return 1===n?"மாதம்":"மாதங்கள்"}),(function(n){return 1===n?"வாரம்":"வாரங்கள்"}),(function(n){return 1===n?"நாள்":"நாட்கள்"}),(function(n){return 1===n?"மணி":"மணிநேரம்"}),(function(n){return"நிமிட"+(1===n?"ம்":"ங்கள்")}),(function(n){return"வினாடி"+(1===n?"":"கள்")}),(function(n){return"மில்லி விநாடி"+(1===n?"":"கள்")})),te:language((function(n){return"సంవత్స"+(1===n?"రం":"రాల")}),(function(n){return"నెల"+(1===n?"":"ల")}),(function(n){return 1===n?"వారం":"వారాలు"}),(function(n){return"రోజు"+(1===n?"":"లు")}),(function(n){return"గంట"+(1===n?"":"లు")}),(function(n){return 1===n?"నిమిషం":"నిమిషాలు"}),(function(n){return 1===n?"సెకను":"సెకన్లు"}),(function(n){return 1===n?"మిల్లీసెకన్":"మిల్లీసెకన్లు"})),uk:language((function(n){return["років","рік","роки"][getSlavicForm(n)]}),(function(n){return["місяців","місяць","місяці"][getSlavicForm(n)]}),(function(n){return["тижнів","тиждень","тижні"][getSlavicForm(n)]}),(function(n){return["днів","день","дні"][getSlavicForm(n)]}),(function(n){return["годин","година","години"][getSlavicForm(n)]}),(function(n){return["хвилин","хвилина","хвилини"][getSlavicForm(n)]}),(function(n){return["секунд","секунда","секунди"][getSlavicForm(n)]}),(function(n){return["мілісекунд","мілісекунда","мілісекунди"][getSlavicForm(n)]}),","),ur:language("سال",(function(n){return 1===n?"مہینہ":"مہینے"}),(function(n){return 1===n?"ہفتہ":"ہفتے"}),"دن",(function(n){return 1===n?"گھنٹہ":"گھنٹے"}),"منٹ","سیکنڈ","ملی سیکنڈ"),sk:language((function(n){return["rok","roky","roky","rokov"][getCzechOrSlovakForm(n)]}),(function(n){return["mesiac","mesiace","mesiace","mesiacov"][getCzechOrSlovakForm(n)]}),(function(n){return["týždeň","týždne","týždne","týždňov"][getCzechOrSlovakForm(n)]}),(function(n){return["deň","dni","dni","dní"][getCzechOrSlovakForm(n)]}),(function(n){return["hodina","hodiny","hodiny","hodín"][getCzechOrSlovakForm(n)]}),(function(n){return["minúta","minúty","minúty","minút"][getCzechOrSlovakForm(n)]}),(function(n){return["sekunda","sekundy","sekundy","sekúnd"][getCzechOrSlovakForm(n)]}),(function(n){return["milisekunda","milisekundy","milisekundy","milisekúnd"][getCzechOrSlovakForm(n)]}),","),sl:language((function(n){return n%10===1?"leto":n%100===2?"leti":n%100===3||n%100===4||Math.floor(n)!==n&&n%100<=5?"leta":"let"}),(function(n){return n%10===1?"mesec":n%100===2||Math.floor(n)!==n&&n%100<=5?"meseca":n%10===3||n%10===4?"mesece":"mesecev"}),(function(n){return n%10===1?"teden":n%10===2||Math.floor(n)!==n&&n%100<=4?"tedna":n%10===3||n%10===4?"tedne":"tednov"}),(function(n){return n%100===1?"dan":"dni"}),(function(n){return n%10===1?"ura":n%100===2?"uri":n%10===3||n%10===4||Math.floor(n)!==n?"ure":"ur"}),(function(n){return n%10===1?"minuta":n%10===2?"minuti":n%10===3||n%10===4||Math.floor(n)!==n&&n%100<=4?"minute":"minut"}),(function(n){return n%10===1?"sekunda":n%100===2?"sekundi":n%100===3||n%100===4||Math.floor(n)!==n?"sekunde":"sekund"}),(function(n){return n%10===1?"milisekunda":n%100===2?"milisekundi":n%100===3||n%100===4||Math.floor(n)!==n?"milisekunde":"milisekund"}),","),sv:language("år",(function(n){return"månad"+(1===n?"":"er")}),(function(n){return"veck"+(1===n?"a":"or")}),(function(n){return"dag"+(1===n?"":"ar")}),(function(n){return"timm"+(1===n?"e":"ar")}),(function(n){return"minut"+(1===n?"":"er")}),(function(n){return"sekund"+(1===n?"":"er")}),(function(n){return"millisekund"+(1===n?"":"er")}),","),sw:assign(language((function(n){return 1===n?"mwaka":"miaka"}),(function(n){return 1===n?"mwezi":"miezi"}),"wiki",(function(n){return 1===n?"siku":"masiku"}),(function(n){return 1===n?"saa":"masaa"}),"dakika","sekunde","milisekunde"),{_numberFirst:true}),tr:language("yıl","ay","hafta","gün","saat","dakika","saniye","milisaniye",","),th:language("ปี","เดือน","สัปดาห์","วัน","ชั่วโมง","นาที","วินาที","มิลลิวินาที"),vi:language("năm","tháng","tuần","ngày","giờ","phút","giây","mili giây",","),zh_CN:language("年","个月","周","天","小时","分钟","秒","毫秒"),zh_TW:language("年","個月","周","天","小時","分鐘","秒","毫秒")};
/**
   * Helper function for creating language definitions.
   *
   * @param {Unit} y
   * @param {Unit} mo
   * @param {Unit} w
   * @param {Unit} d
   * @param {Unit} h
   * @param {Unit} m
   * @param {Unit} s
   * @param {Unit} ms
   * @param {string} [decimal]
   * @returns {Language}
   */function language(n,r,t,u,e,i,o,a,c){
/** @type {Language} */
var f={y:n,mo:r,w:t,d:u,h:e,m:i,s:o,ms:a};"undefined"!==typeof c&&(f.decimal=c);return f}
/**
   * Helper function for Arabic.
   *
   * @param {number} c
   * @returns {0 | 1 | 2}
   */function getArabicForm(n){return 2===n?1:n>2&&n<11?2:0}
/**
   * Helper function for Polish.
   *
   * @param {number} c
   * @returns {0 | 1 | 2 | 3}
   */function getPolishForm(n){return 1===n?0:Math.floor(n)!==n?1:n%10>=2&&n%10<=4&&!(n%100>10&&n%100<20)?2:3}
/**
   * Helper function for Slavic languages.
   *
   * @param {number} c
   * @returns {0 | 1 | 2 | 3}
   */function getSlavicForm(n){return Math.floor(n)!==n?2:n%100>=5&&n%100<=20||n%10>=5&&n%10<=9||n%10===0?0:n%10===1?1:n>1?2:0}
/**
   * Helper function for Czech or Slovak.
   *
   * @param {number} c
   * @returns {0 | 1 | 2 | 3}
   */function getCzechOrSlovakForm(n){return 1===n?0:Math.floor(n)!==n?1:n%10>=2&&n%10<=4&&n%100<10?2:3}
/**
   * Helper function for Lithuanian.
   *
   * @param {number} c
   * @returns {0 | 1 | 2}
   */function getLithuanianForm(n){return 1===n||n%10===1&&n%100>20?0:Math.floor(n)!==n||n%10>=2&&n%100>20||n%10>=2&&n%100<10?1:2}
/**
   * Helper function for Latvian.
   *
   * @param {number} c
   * @returns {boolean}
   */function getLatvianForm(n){return n%10===1&&n%100!==11}function assign(n){var r;for(var t=1;t<arguments.length;t++){r=arguments[t];for(var u in r)has(r,u)&&(n[u]=r[u])}return n}var e=Array.isArray||function(n){return"[object Array]"===Object.prototype.toString.call(n)};function has(n,r){return Object.prototype.hasOwnProperty.call(n,r)}
/**
   * @param {Pick<Required<Options>, "language" | "fallbacks" | "languages">} options
   * @throws {Error} Throws an error if language is not found.
   * @returns {Language}
   */function getLanguage(n){var r=[n.language];if(has(n,"fallbacks")){if(!e(n.fallbacks)||!n.fallbacks.length)throw new Error("fallbacks must be an array with at least one element");r=r.concat(n.fallbacks)}for(var t=0;t<r.length;t++){var i=r[t];if(has(n.languages,i))return n.languages[i];if(has(u,i))return u[i]}throw new Error("No language found.")}
/**
   * @param {Piece} piece
   * @param {Language} language
   * @param {Pick<Required<Options>, "decimal" | "spacer" | "maxDecimalPoints" | "digitReplacements">} options
   */function renderPiece(n,r,t){var u=n.unitName;var e=n.unitCount;var i=t.spacer;var o=t.maxDecimalPoints;
/** @type {string} */var a;a=has(t,"decimal")?t.decimal:has(r,"decimal")?r.decimal:"."
/** @type {undefined | DigitReplacements} */;var c;"digitReplacements"in t?c=t.digitReplacements:"_digitReplacements"in r&&(c=r._digitReplacements)
/** @type {string} */;var f;var g=void 0===o?e:Math.floor(e*Math.pow(10,o))/Math.pow(10,o);var s=g.toString();if(c){f="";for(var m=0;m<s.length;m++){var l=s[m];f+="."===l?a:c[l]}}else f=s.replace(".",a);var d=r[u];var v;v="function"===typeof d?d(e):d;return r._numberFirst?v+i+f:f+i+v}
/**
   * @typedef {Object} Piece
   * @prop {UnitName} unitName
   * @prop {number} unitCount
   */
/**
   * @param {number} ms
   * @param {Pick<Required<Options>, "units" | "unitMeasures" | "largest" | "round">} options
   * @returns {Piece[]}
   */function getPieces(n,r){
/** @type {UnitName} */
var t;
/** @type {number} */var u;
/** @type {number} */var e;
/** @type {number} */var i;var o=r.units;var a=r.unitMeasures;var c="largest"in r?r.largest:Infinity;if(!o.length)return[];
/** @type {Partial<Record<UnitName, number>>} */var f={};i=n;for(u=0;u<o.length;u++){t=o[u];var g=a[t];var s=u===o.length-1;e=s?i/g:Math.floor(i/g);f[t]=e;i-=e*g}if(r.round){var m=c;for(u=0;u<o.length;u++){t=o[u];e=f[t];if(0!==e){m--;if(0===m){for(var l=u+1;l<o.length;l++){var d=o[l];var v=f[d];f[t]+=v*a[d]/a[t];f[d]=0}break}}}for(u=o.length-1;u>=0;u--){t=o[u];e=f[t];if(0!==e){var k=Math.round(e);f[t]=k;if(0===u)break;var h=o[u-1];var F=a[h];var y=Math.floor(k*a[t]/F);if(!y)break;f[h]+=y;f[t]=0}}}
/** @type {Piece[]} */var S=[];for(u=0;u<o.length&&S.length<c;u++){t=o[u];e=f[t];e&&S.push({unitName:t,unitCount:e})}return S}
/**
   * @param {Piece[]} pieces
   * @param {Pick<Required<Options>, "units" | "language" | "languages" | "fallbacks" | "delimiter" | "spacer" | "decimal" | "conjunction" | "maxDecimalPoints" | "serialComma" | "digitReplacements">} options
   * @returns {string}
   */function formatPieces(n,r){var t=getLanguage(r);if(!n.length){var u=r.units;var e=u[u.length-1];return renderPiece({unitName:e,unitCount:0},t,r)}var i=r.conjunction;var o=r.serialComma;var a;a=has(r,"delimiter")?r.delimiter:has(t,"delimiter")?t.delimiter:", "
/** @type {string[]} */;var c=[];for(var f=0;f<n.length;f++)c.push(renderPiece(n[f],t,r));return i&&1!==n.length?2===n.length?c.join(i):c.slice(0,-1).join(a)+(o?",":"")+i+c.slice(-1):c.join(a)}function humanizer(n){var r=function humanizer(n,t){n=Math.abs(n);var u=assign({},r,t||{});var e=getPieces(n,u);return formatPieces(e,u)};return assign(r,{language:"en",spacer:" ",conjunction:"",serialComma:true,units:["y","mo","w","d","h","m","s"],languages:{},round:false,unitMeasures:{y:315576e5,mo:26298e5,w:6048e5,d:864e5,h:36e5,m:6e4,s:1e3,ms:1}},n)}var i=humanizer({});i.getSupportedLanguages=function getSupportedLanguages(){var n=[];for(var r in u)has(u,r)&&"gr"!==r&&n.push(r);return n};i.humanizer=humanizer;r?r=i:(this||n).humanizeDuration=i})();var t=r;export{t as default};

