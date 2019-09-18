class Persona {
	var enfermedades = #{}
	var temperatura
	var cantidadCelulas
	var factorSanguineo = factorO
	
	method contraerEnfermedad(unaEnfermedad) {
		enfermedades.add(unaEnfermedad)
	}
	
	method contrajo(unaEnfermedad) {
		return enfermedades.contains(unaEnfermedad)
	}
	
	method vivirUnDia() {
		enfermedades.forEach { enfermedad => enfermedad.aplicarEfecto(self) }
	}
	
	method aumentarTemperatura(unosGrados) {
		temperatura = 45.min(temperatura + unosGrados)
	}
	
	method destruirCelulas(cantidadCelulasADestruir) {
		cantidadCelulas -= cantidadCelulasADestruir
	}
	
	method cantidadCelulasAmenazadasPorEnfermedadesAgresivas() {
		return self.enfermedadesAgresivas().sum { enfermedad => enfermedad.cantidadCelulasAmenazadas() }
	}
	
	method enfermedadesAgresivas() {
		return enfermedades.filter { enfermedad => enfermedad.esAgresiva(cantidadCelulas) }
	}
	
	method aplicarDosis(unaDosis) {
		enfermedades.forEach { enfermedad => 
			enfermedad.recibirDosis(unaDosis * 15, self)
		}
	}
	
	method curarse(unaEnfermedad) {
		enfermedades.remove(unaEnfermedad)
	}
	
	method donar(unasCelulas) {
		self.destruirCelulas(unasCelulas)
	}

	method recibir(unasCelulas) {
		cantidadCelulas += unasCelulas
	}

	method puedeDonar(unasCelulas) {
		return unasCelulas > 500 && unasCelulas <= self.maximoATransferir()
	}

	method esCompatibleCon(unaPersona) {
		return factorSanguineo.puedeDonar(unaPersona.factorSanguineo()) && unaPersona.factorSanguineo().puedeRecibirDe(self.factorSanguineo())
	}

	method maximoATransferir() {
		return cantidadCelulas / 4	
	}
	
	method enfermedadQueMasCelulasAfecte() {
		return enfermedades.max { enfermedad => enfermedad.cantidadCelulasAmenazadas() }
	}

	method estaEnComa() {
		return temperatura == 45 || cantidadCelulas < 1000000
	}

	// Esta es una sintaxis copada que se puede usar en wollok cuando necesitas retornar algo en una sola línea

	method temperatura() = temperatura
	method enfermedades() = enfermedades
	method cantidadCelulas() = cantidadCelulas
	method factorSanguineo() = factorSanguineo
}

class Enfermedad {
	var property cantidadCelulasAmenazadas
	
	method aplicarEfecto(unaPersona)
	method esAgresiva(cantidadCelulasPersona)

	method atenuarEn(cantidadCelulas) {
		cantidadCelulasAmenazadas -= cantidadCelulas
	}
	
	method recibirDosis(cantidadCelulas, unaPersona) {
		self.atenuarEn(cantidadCelulas)
		if (cantidadCelulasAmenazadas <= 0) {
			unaPersona.curarse(self)
		}
	}
}


class EnfermedadInfecciosa inherits Enfermedad {

	method reproducirse() {
		cantidadCelulasAmenazadas *= 2
	}
	
	override method aplicarEfecto(unaPersona) {
		unaPersona.aumentarTemperatura(cantidadCelulasAmenazadas / 1000)
	}
	
	override method esAgresiva(cantidadCelulasPersona) {
		return cantidadCelulasAmenazadas > cantidadCelulasPersona * 0.1 
	}
}

class EnfermedadAutoinmune inherits Enfermedad {
	var diasQueAfectaste = 0

	override method aplicarEfecto(unaPersona) {
		unaPersona.destruirCelulas(cantidadCelulasAmenazadas)
		diasQueAfectaste ++
	}

	override method esAgresiva(cantidadCelulasPersona) {
		return diasQueAfectaste > 30 
	}
	
}

class Medicx inherits Persona {
	var dosis = 0
	
	method atenderA(unaPersona) {
		unaPersona.aplicarDosis(dosis)
	}
	
	override method contraerEnfermedad(unaEnfermedad) {
		super(unaEnfermedad)
		self.atenderA(self)
	}	
	
	method dosis() = dosis	
}

class JefeDeDepartamento inherits Medicx {
	var subordinados = #{}

	override method atenderA(unaPersona) {
		subordinados.anyOne().atenderA(unaPersona)		
	}
}

class Transfusion {
	var donante
	var receptor
	var cantidadDeCelulas

	method realizar() {
		self.validarDonante()
		self.validarCompatibilidad()
		donante.donar(cantidadDeCelulas)
		receptor.recibir(cantidadDeCelulas)
	}

	method validarDonante() {
		if (donante.puedeDonar(cantidadDeCelulas).negate()) {
			throw new TransfusionException(message = "El donante no puede donar!!")
		}
	}

	method validarCompatibilidad() {
		if (donante.esCompatibleCon(receptor).negate()) {
			throw new TransfusionException(message = "Donante y receptor no son compatibles")
		}
	}

}

class TransfusionException inherits Exception {}

object factorA {
	method puedeDonarA(otroFactor) {
		return otroFactor.equals(self) || otroFactor.equals(factorR) 	
	}

	method puedeRecibirDe(otroFactor) {
		return otroFactor.equals(self) || otroFactor.equals(factorO) 	
	}
}

object factorR {
	method puedeDonarA(otroFactor) {
		return otroFactor.equals(self) 	
	}

	method puedeRecibirDe(otroFactor) {
		return true	
	}	
}

object factorO {
	method puedeDonarA(otroFactor) {
		return true 	
	}

	method puedeRecibirDe(otroFactor) {
		return otroFactor.equals(factorA)
	}	
}