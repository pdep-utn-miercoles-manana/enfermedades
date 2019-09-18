class Persona {
	var enfermedades = #{}
	var temperatura
	var cantidadCelulas
	
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
		enfermedades.forEach { enfermedad => 
			enfermedad.recibirDosis(unaDosis * 15, self)
		}
	}
	
	method curarse(unaEnfermedad) {
		enfermedades.remove(unaEnfermedad)
	}
	
	method temperatura() = temperatura
	method cantidadCelulas() = cantidadCelulas
	method enfermedades() = enfermedades
	
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
	var dosis = 678
	
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












