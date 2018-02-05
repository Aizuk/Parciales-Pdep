class Persona{
	var edad
	var carreraDeseada
	var carrera
	var plataDeseada
	var lugares
	var hijos
	var sueniosCumplidos
	var sueniosPendientes
	var tipoPersona
	constructor(_edad,_carreraDeseada,_carrera,_plataDeseada,_lugares,_hijos,_sueniosCumplidos,_sueniosPendientes,_tipoPersona){
		edad = _edad
		carreraDeseada = _carreraDeseada
		carrera = _carrera
		plataDeseada = _plataDeseada
		lugares = _lugares
		hijos = _hijos
		sueniosCumplidos = _sueniosCumplidos
		sueniosPendientes = _sueniosPendientes
		tipoPersona = _tipoPersona
	}
	method cumplirSuenio() {tipoPersona.elegirSuenio(sueniosPendientes).cumplirse()}
	method carrera() = carrera
	method quiereEstudiar(unaCarrera) = carreraDeseada == unaCarrera
	method seRecibio(unaCarrera) = carrera == unaCarrera
	method ganaSuficiente(ingreso) = ingreso >= plataDeseada
	method tieneHijos() = hijos > 0
	method suenioCumplido(suenio){
		sueniosCumplidos.add(suenio)
		sueniosPendientes.remove(suenio)	
	}
	method feliz() = self.felicidoniosCumplidos() > self.felicidoniosPendientes()
	method felicidoniosCumplidos() = sueniosCumplidos.sum({suenio=>suenio.felicidonio()})
	method felicidoniosPendientes() = sueniosPendientes.sum({suenio=>suenio.felicidonio()})
	method ambicioso() = sueniosCumplidos.count({suenio=>suenio.felicidonio()>100}) + sueniosCumplidos.count({suenio=>suenio.felicidonio()>100}) >= 3
}

object realista{
	method elegirSuenio(sueniosPendientes) = sueniosPendientes.max({suenio=>suenio.felicidonio()})
}

object alocado{
	method elegirSuenio(sueniosPendientes) = sueniosPendientes.random()
}

object obsesivo{
	method elegirSuenio(sueniosPendientes) = sueniosPendientes.head()
}

class Suenio{
	var felicidonio
	constructor(_felicidonio){
		felicidonio = _felicidonio
	}
	method cumplirse(persona) {
		if(self.cumpleCondiciones(persona)) {
			self.hacerEfecto(persona)
		}
		else {
			throw new Exception("No cumple condiciones")
		}
	}
	method cumpleCondiciones(persona) = true
	method hacerEfecto(persona) {persona.suenioCumplido(self)}
	method felicidonio() = felicidonio
}

class SuenioCarrera inherits Suenio{
	var carrera
	constructor(_carrera,_felicidonio) = super(_felicidonio){
		carrera = _carrera
	}
	override method cumpleCondiciones(persona) = persona.carrera()!=carrera && persona.quiereEstudiar(persona.carreraDeseada())
	override method hacerEfecto(persona) {
		persona.nuevaCarrera(carrera)
		super(persona)
	}
}

class SuenioHijo inherits Suenio{
	constructor(_felicidonio) = super(_felicidonio)
	override method hacerEfecto(persona) {
		persona.tenerHijo()
		super(persona)
	}
	
}

class SuenioAdopcion inherits Suenio{
	var hijos
	constructor(_hijos,_felicidonio) = super(_felicidonio){
		hijos = _hijos
	}
	override method cumpleCondiciones(persona) = !persona.tieneHijos()
	override method hacerEfecto(persona) {
		persona.tenerHijos(hijos)
		super(persona)
	}
}

class SuenioLugar inherits Suenio{
	var lugar
	constructor(_lugar,_felicidonio) = super(_felicidonio){
		lugar = _lugar
	}
}

class SuenioLaburo inherits Suenio{
	var nuevosIngresos
	constructor(_nuevosIngresos,_felicidonio) = super(_felicidonio){
		nuevosIngresos = _nuevosIngresos
	}
	override method cumpleCondiciones(persona) = persona.ganaSuficiente(nuevosIngresos)
}

class SuenioMultiple inherits Suenio{
	var suenios
	constructor(_suenios) = super(0){
		suenios = _suenios
	}
	override method cumpleCondiciones(persona) = suenios.all({suenio=>suenio.cumpleCondiciones(persona)})
	override method hacerEfecto(persona) {suenios.forEach({suenio=>suenio.hacerEfecto(persona)})}
}