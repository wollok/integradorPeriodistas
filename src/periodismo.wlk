object mundo {
	
	var property paises = [argentina]
	
	method agregarPais(pais) {
		paises.add(pais)
	}
	
	//Saber cuál es el país con la mejor situación económica del mundo, segun una estrategia indicada para calcularlo.
	method mejorPais(estrategia) = paises.max{pais=>estrategia.cifra(pais)}
	
}

object pbiPerCapita{
	method cifra(pais) = pais.pbiPerCapita() 
}

object gini{
	method cifra(pais) = pais.distribucion() 
}

object ingresosAltos{
	method cifra(pais) = pais.ingresosAltos()	
}

object accesoUniversidad{
	method cifra(pais) = pais.porcentajeUniversitario()
}

object nombrista{
	method cifra(pais) = pais.nombre().size() * 10
}

class Pais{
	
	const property nombre
	const pbi
	const poblacion
	const property porcentajeUniversitario
	const ingresos
	
	method pbiPerCapita() = pbi / poblacion

	method distribucion() = ingresos.last()/ingresos.first()
	
	method situacionEconomica(estrategias) = estrategias.map{estrategia=>estrategia.cifra(self)}
}

const argentina = new Pais(
		nombre = "Argentina",
		porcentajeUniversitario = 50,
		ingresos = [4290, 9807, 13681, 16199, 19259, 24101, 29614, 36642, 46579, 87758],
		poblacion = 43000000,
		pbi = 500000000
	)
	

object diario {

	var property analistas = []
	const articulos = [] 
	
//	Realizar una edición de un diario a partir de un país, que consiste en actualizar el historial de artículos con los nuevos artículos generados y su correspondiente detalle.
	method nuevaEdicion(pais){
		articulos.addAll(self.generarArticulos(pais))
	}
	
	method generarArticulos(pais) = self.analistasHabilitados(pais).map({analista=> analista.nuevoArticulo(pais)})

	method analistasHabilitados(pais) = analistas.filter({analista => self.pocosArticulos(analista) and analista.nombreDiferente(pais)})
        
	method pocosArticulos(analista) = articulos.count{articulo=>articulo.autor() == analista} < 3
		
}

class Articulo{
	
	const property titulo
	const property cifraDestacada
	const property analista
	
}

class Analista{
	
	method escribirArticulo(pais){
		return new Articulo(titulo = self.titulo(pais) , cifraDestacada = self.cifraDestacada(pais), analista = self)
	}

	method titulo(pais)

	method cifraDestacada(pais)
			
}

class Clasico inherits Analista{
	
	override method titulo(pais) = "La situacion en " + pais.nombre()
	
	override method cifraDestacada(pais) = pbiPerCapita.cifra(pais)
	
}

class Rebelde inherits Analista{

	var property estrategia
	
	override method titulo(pais) = "Mejor pais del mundo"  
	
	override method cifraDestacada(pais) = estrategia.cifra(mundo.mejorPais(estrategia))
	
}

class Panqueque inherits Analista{
	
	const nombre
	const simpatia
	const estrategiaPositiva
	const estrategiaNegativa
	
	method tieneSimpatiaPor(pais) = simpatia.contains(pais)
	
	override method titulo(pais ) = "La columna económica de " + nombre 
	
	override method cifraDestacada(pais) = 
		(if(self.tieneSimpatiaPor(pais)) estrategiaPositiva else estrategiaNegativa).mostrarCifra(pais)

}

object juancipayo inherits Panqueque (simpatia = [argentina], estrategiaPositiva = gini, estrategiaNegativa = pbiPerCapita) {
	
	override method cifraDestacada(pais) = super(pais)*1.5
}

class Salieris inherits Analista{
	
	var property otroAnalista 
		
	override method titulo(pais) = otroAnalista.titulo(pais)
	
	override method cifraDestacada(pais) = otroAnalista.cifraDestacada(pais)
}

// Analistas inventados 
class Sinverguenza inherits Analista{
	
	override method titulo(pais) = "Exito economico"
	
	override method cifraDestacada(pais) = nombrista.cifra(pais)
	
}