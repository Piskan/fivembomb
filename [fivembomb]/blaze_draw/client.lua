

function DrawGonder(goster, yazi, yazituru)
    Geldimi(goster, yazi, yazituru)
end

function Geldimi(goster, yazi, yazituru)

	SendNUIMessage({
		 goster = goster,
		 text = yazi,
		 tur = yazituru
	})
 


end





