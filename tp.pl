persona(bakunin).
persona(ravachol).
persona(rosaDubovsky).
persona(emmaGoldman). 
persona(judithButler).
persona(elisaBachofen).
persona(juanSuriano).
persona(sebastienFaure).


% trabajaEn(Persona, Trabajo)
trabajaEn(elisaBachofen, ingenieriaMecanica).
trabajaEn(bakunin, aviacionMilitar).
trabajaEn(ravachol, inteligenciaMilitar).
trabajaEn(rosaDubovsky, recolectorDeBasura).
trabajaEn(rosaDubovsky, asesinaASueldo).
trabajaEn(emmaGoldman, profesoraDeJudo).
trabajaEn(emmaGoldman, cineasta).
trabajaEn(judithButler, profesoraDeJudo).
trabajaEn(judithButler, inteligenciaMilitar).


% gustos(Persona, Gusto) 
gusto(ravachol, juegosDeAzar).
gusto(ravachol, ajedrez).
gusto(ravachol, tiroAlBlanco).
gusto(rosaDubovsky,construirPuentes).
gusto(rosaDubovsky, mirarPeppaPig).
gusto(rosaDubovsky, fisicaCuantica).
gusto(emmaGoldman, judo).
gusto(emmaGoldman, automovilismo).
gusto(judithButler, judo).
gusto(judithButler, automovilismo).
gusto(elisaBachofen, fuego).
gusto(elisaBachofen, destruccion).
gusto(juanSuriano, judo).
gusto(juanSuriano, armarBombas).
gusto(juanSuriano, ringRaje).


% habilidad(Persona, Gustos)
habilidad(bakunin, conducirAutos).
habilidad(ravachol, tiroAlBlanco).
habilidad(rosaDubovsky, construirPuentes).
habilidad(rosaDubovsky, mirarPeppaPig).
habilidad(emmaGoldman, judo).
habilidad(emmaGoldman, armarBombas).
habilidad(judithButler, judo).
habilidad(elisaBachofen, armarBombas).
habilidad(juanSuriano,judo).
habilidad(juanSuriano, armarBombas).
habilidad(juanSuriano, ringRaje).


% historial(Persona, Delito)
historial(bakunin, roboDeAeronaves).
historial(bakunin, fraude).
historial(bakunin, tenenciaDeCafeina).
historial(ravachol, falsificarVacunas).
historial(ravachol, fraude).
historial(judithButler, falsificarCheques).
historial(judithButler, fraude).
historial(juanSuriano, falsificarDinero).
historial(juanSuriano, fraude).

% viveEn(Persona, LugarDondeVive)
viveEn(bakunin, laSeverino).
viveEn(elisaBachofen, laSeverino).
viveEn(rosaDubovsky, laSeverino).
viveEn(ravachol, comisaria48).
viveEn(emmaGoldman, laCasaDePapel).
viveEn(juanSuriano, laCasaDePapel).
viveEn(judithButler, laCasaDePapel).


% viveCon(Persona1, Persona2)
vive(bakunin, elisaBachofen ).
vive(bakunin, rosaDubovsky).
vive(emmaGoldman,juanSuriano).
vive(emmaGoldman,judithButler).
viveCon(A,B):- vive(A,B).
viveCon(A,B):- vive(B,A).


% vivienda(Nombre, Composicion)
vivienda(laSeverino, [cuartoSecreto(4, 8), pasadizo, tunel(8, finalizado), tunel(5, finalizado), tunel(1, enConstruccion)]).
vivienda(comisaria48, []).
vivienda(laCasaDePapel, [cuartoSecreto(5,3), cuartoSecreto(4,7), pasadizo, pasadizo, tunel(9, finalizado), tunel(2, finalizado)]).
vivienda(casaDelSolNaciente, [pasadizo, tunel(3, sinConstruir)]).


esDisidente(Persona):-
  persona(Persona),
  tieneHabilidadTerrorista(Persona),
  requisitoB(Persona),
  requisitoC(Persona).

tieneHabilidadTerrorista(Persona):-
  habilidad(Persona, Habilidad),
  habilidadEsTerrorista(Habilidad).

habilidadEsTerrorista(armarBombas).
habilidadEsTerrorista(tiroAlBlanco).
habilidadEsTerrorista(mirarPeppaPig).

requisitoB(Persona):-
  persona(Persona),
  not(tieneGustoRegistrado(Persona)).

requisitoB(Persona):-
  leGustaAlgoEnLoQueEsBueno(Persona).

tieneGustoRegistrado(Persona):-
  gusto(Persona, _).

leGustaAlgoEnLoQueEsBueno(Persona):-
  gusto(Persona, Gusto),
  habilidad(Persona, Gusto).

requisitoC(Persona):-
  tieneMasDeUnRegistroEnSuHistorial(Persona).

requisitoC(Persona):-
  viveConAlguienConMasDeUnRegistroEnElHistorial(Persona).

tieneMasDeUnRegistroEnSuHistorial(Persona):-
  persona(Persona),
  historial(Persona, UnRegistro),
  historial(Persona, OtroRegistro),
  UnRegistro \= OtroRegistro.

viveConAlguienConMasDeUnRegistroEnElHistorial(Persona):-
  persona(Persona),
  viveCon(Persona, SuCompaniero),
  tieneMasDeUnRegistroEnSuHistorial(SuCompaniero).




noViveNadie(Casa):-
  vivienda(Casa, _),
  not(viveEn(_, Casa)).

losQueVivenTienenGustoEnComun(Casa):-
  vivienda(Casa, _),
  viveEn(UnaPersona, Casa),
  forall((viveEn(OtraPersona, Casa), UnaPersona \= OtraPersona),
        (gusto(UnaPersona, GustoComun), gusto(OtraPersona, GustoComun))).


%  viviendaRebelde(Casa)

viviendaRebelde(Casa):-
  vivienda(Casa, _),
  viveEn(UnaPersona, Casa),
  esDisidente(UnaPersona),
  superficie(Casa, SuSuperficie),
  SuSuperficie > 50.

superficie(Casa, SuperficieTotal):-
  vivienda(Casa, Composicion),
  findall(Superficie,(member(Componente, Composicion), superficieUnitaria(Componente, Superficie)),LasSuperficies),
  sumlist(LasSuperficies, SuperficieTotal).



superficieUnitaria(cuartoSecreto(A,B), Superficie):- Superficie is A*B.
superficieUnitaria(tunel(Largo, finalizado), Superficie):- Superficie is 2*Largo.
superficieUnitaria(tunel(_, enConstruccion), 0). 
superficieUnitaria(pasadizo, 1).

/*
6. Si en algún momento se agregara algún tipo nuevo de ambiente en las
   viviendas, por ejemplo bunkers que tienen un perímetro de acceso y una superficie interna, 
   de manera de que la superficie total sea superficie interna + perímetro de acceso. 
   ¿Qué debe modificar de su solución actual?

   En el caso de agregar un bunker lo unico que habria que hacer es implementar un predicado del tipo:
   superficieUnitaria(bunker(interna, perimetro), Superficie):- Superficie is interna + perimetro.
*/
vivienda(laCasaDePatricia , [pasadizo, bunker(10, 2)]).
viveEn(sebastienFaure, laCasaDePatricia).