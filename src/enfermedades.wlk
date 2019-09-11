class Persona {
	const property enfermedades = #{}
	var property temperatura
	var property cantidadCelulas
	
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
		return self.enfermedadesAgresivas().sum { enfermedad => 
			enfermedad.cantidadCelulasAmenazadas()
		}
	}
	
	method enfermedadesAgresivas() {
		return enfermedades.filter { enfermedad => 
			enfermedad.esAgresiva(cantidadCelulas)
		}
	}
	
	method aplicarDosis(unaDosis) {
		enfermedades.forEach { enfermedad => enfermedad.atenuarEn(unaDosis * 15) }
	}
}

class EnfermedadInfecciosa {
	var property cantidadCelulasAmenazadas
	
	method reproducirse() {
		cantidadCelulasAmenazadas *= 2
	}
	
	method aplicarEfecto(unaPersona) {
		unaPersona.aumentarTemperatura(cantidadCelulasAmenazadas / 1000)
	}
	
	method esAgresiva(cantidadCelulasPersona) {
		return cantidadCelulasAmenazadas > cantidadCelulasPersona * 0.1 
	}

	method atenuarEn(cantidadCelulas) {
		cantidadCelulasAmenazadas -= cantidadCelulas
	}
}

class EnfermedadAutoinmune {
	var property cantidadCelulasAmenazadas
	var diasQueAfectaste = 0

	method aplicarEfecto(unaPersona) {
		unaPersona.destruirCelulas(cantidadCelulasAmenazadas)
		diasQueAfectaste ++
	}

	method esAgresiva(cantidadCelulasPersona) {
		return diasQueAfectaste > 30 
	}
	
	method atenuarEn(cantidadCelulas) {
		cantidadCelulasAmenazadas -= cantidadCelulas
	}
}

class Medicx inherits Persona {
	var property dosis
	
	method atenderA(unaPersona) {
		unaPersona.aplicarDosis(dosis)
	}
}











