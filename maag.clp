(defglobal ?*maag* = 0)
(defglobal ?*GERD* = 0)
(defglobal ?*gas* = 0)

(defrule sakit-perut 
    =>
    (printout t "Apakah perut Anda sering terasa sakit? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (sakit_perut))
            (bind ?*maag* (+ ?*maag* 3))
        else
            (assert (tidak_sakit_perut))
    )
)

(defrule kembung-begah
    (or(sakit_perut) (tidak_sakit_perut))
    =>
    (printout t "Apakah perut Anda sering terasa begah/kembung setelah makan? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (kembung_begah))
            (bind ?*maag* (+ ?*maag* 1))
        else
            (assert (tidak_kembung_begah))
    )
)

(defrule mual-muntah
    (or(kembung_begah) (tidak_kembung_begah))
    =>
    (printout t "Apakah Anda sering merasa mual atau muntah? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (mual_muntah))
            (bind ?*maag* (+ ?*maag* 2))
        else
            (assert (tidak_mual_muntah))
    )
)

(defrule asam-pahit
    (or(mual_muntah) (tidak_mual_muntah))
    =>
    (printout t "Apakah mulut Anda terasa asam atau pahit pada bagian pangkal lidah? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (asam_pahit))
            (bind ?*maag* (+ ?*maag* 1))
        else
            (assert (tidak_asam_pahit))
    )
)

(defrule sendawa
    (or(asam_pahit) (tidak_asam_pahit))
    =>
    (printout t "Apakah Anda sering bersendawa? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (sendawa))
            (bind ?*maag* (+ ?*maag* 2))
        else
            (assert (tidak_sendawa))
    )
)

(defrule mudah-kenyang
    (or(sendawa) (tidak_sendawa))
    =>
    (printout t "Apakah Anda cepat kenyang ketika makan sehingga hanya makan sedikit? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (mudah_kenyang))
            (bind ?*maag* (+ ?*maag* 1))
        else
            (assert (tidak_mudah_kenyang))
    )
)

(defrule check1
    (or (mudah_kenyang) (tidak_mudah_kenyang))
    =>
    (if (eq ?*maag* 0) then (printout t crlf "Anda tidak terindikasi menderita penyakit maag. Tetap jaga kesehatan!" crlf))
    (if (and(> ?*maag* 0) (< ?*maag* 8)) then (printout t crlf "Anda terindikasi menderita penyakit maag dengan gejala ringan." crlf "Jaga pola hidup, pola makan, dan kelola stress Anda dengan baik." crlf))
    (if (> ?*maag* 7) then (assert (checkGERD)))
)

;============================================= check GERD

(defrule heart-burn
    (checkGERD)
    =>
    (printout t "Dari skala 1-5 seberapa dada Anda terasa nyeri/terbakar?" crlf)
    (bind ?answer (read))
    (if(> ?answer 2)
        then
            (bind ?*GERD* (+ ?*GERD* ?answer))
            (assert (heart_burn))
        else (assert (tidak_heart_burn))
    )
)

(defrule batuk
    (or(heart_burn) (tidak_heart_burn))
    =>
    (printout t "Apakah Anda sering batuk? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (batuk))
            (bind ?*GERD* (+ ?*GERD* 1))
        else
            (assert (tidak_batuk))
    )
)

(defrule sakit-tenggorokan
    (or(batuk) (tidak_batuk))
    =>
    (printout t "Apakah tenggorokan Anda terasa sakit? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (sakit_tenggorokan))
            (bind ?*GERD* (+ ?*GERD* 1))
        else
            (assert (tidak_sakit_tenggorokan))
    )
)

(defrule suara-serak
    (or(sakit_tenggorokan) (tidak_sakit_tenggorokan))
    =>
    (printout t "Apakah suara Anda serak? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then 
            (assert (suara_serak))
            (bind ?*GERD* (+ ?*GERD* 1))
        else
            (assert (tidak_suara_serak))
    )
)

(defrule isGERD
    (or (suara_serak) (tidak_suara_serak))
    =>
    (if (> ?*GERD* 4)
        then
            (bind ?*maag* (+ ?*maag* 5))
            (assert (GERD))
        else (assert (noGERD))
    )
)

;============================================= Check Gasritis

(defrule feses-hitam
    (or (GERD) (noGERD))
    =>
    (printout t "Apakah feses Anda berwarna gelap/hitam? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then
            (bind ?*gas* (+ ?*gas* 1))
            (assert (feses_hitam))
        else
            (assert (tidak_feses_hitam))
    )
)

(defrule muntah-hitam
    (or (feses_hitam) (tidak_feses_hitam))
    =>
    (printout t "Apakah ketika muntah, Muntah Anda berwarna gelap/cokelat tua/hitam? (Y/N)" crlf)
    (bind ?answer (read))
    (if (eq ?answer Y)
        then
            (bind ?*gas* (+ ?*gas* 1))
            (assert (muntah_hitam))
        else
            (assert (tidak_muntah_hitam))
    )
)

(defrule isGasritis
    (or(muntah_hitam) (tidak_muntah_hitam))
    =>
    (if (> ?*gas* 0)
        then
            (bind ?*maag* (+ ?*maag* 10)) 
            (assert(Gasritis))
        else (assert(noGasritis))
    )
)


(defrule diagnosis
    (or(noGasritis) (Gasritis))
    =>
    (if (and(> ?*maag* 12)(< ?*maag* 16)) then (printout t crlf "Anda terindikasi menderita penyakit maag akut yang disertai GERD." crlf "Hindari makanan pedas, berlemak, dan asam serta jangan merokok dan minum minuman beralkohol." crlf))
    (if (and(> ?*maag* 17)(< ?*maag* 21)) then (printout t crlf "Anda terindikasi menderita penyakit maag akut yang disertai Gasritis." crlf "Hindari makanan pedas, berlemak, dan asam serta jangan merokok dan minum minuman beralkohol." crlf)) 
    (if (and(> ?*maag* 22)(< ?*maag* 26)) then (printout t crlf "Anda terindikasi menderita penyakit maag kronis yang disertai GERD dan Gasritis." crlf " Segera ambil tindakan penanganan dan konsultasikan ke dokter" crlf))
)