class Inmueble{
	var tamanio
	var cantAmbientes
	var tipoOperacion
	var zona
	constructor(_tamanio,_cantAmbientes,_tipoOperacion,_zona){
		tamanio = _tamanio
		cantAmbientes = _cantAmbientes
		tipoOperacion = _tipoOperacion
		zona = _zona
	}	
	method valor()
	method plusZonal() = zona.plusZonal()
	method cambiarZona(nueva) {zona = nueva}
	method comision() = tipoOperacion.comision()
}

class Casa inherits Inmueble{
	var valor
	constructor(_valor,_tamanio,_cantAmbientes,_tipoOperacion,_zona) = super (_tamanio,_cantAmbientes,_tipoOperacion,_zona){
		valor = _valor
		}
	override method valor() = valor * self.plusZonal()
}

class PH inherits Inmueble{
	const precioMetroCuadrado = 14000
	override method valor() = (tamanio*precioMetroCuadrado).min(500000) * self.plusZonal()
}

class Departamento inherits Inmueble{
	const precioAmbiente = 350000
	override method valor() = cantAmbientes*precioAmbiente * self.plusZonal()
}

class Local inherits Casa{
	var tipo
	constructor(_tipo,_valor,_tamanio,_cantAmbientes,_tipoOperacion,_zona) = super(_valor,_tamanio,_cantAmbientes,_tipoOperacion,_zona){
		tipo = _tipo
	}
	override method valor() = tipo.valor(super().valor())
}

object galpon{
	method valor(valorOriginal) = valorOriginal/2
}

object aLaCalle{
	var montoFijo = 10000
	method fijarMontoFijo(monto) {montoFijo = monto}
	method valor(valorOriginal) = valorOriginal + montoFijo
}

class Zona{
	var plusZonal
	constructor(_plusZonal){
		plusZonal = _plusZonal
	}
	method plusZonal() = plusZonal
}

object venta{
	var porcentaje = 1.5
	method cambiarPorcentaje(nuevo) {porcentaje = nuevo}
	method comision(inmueble) = inmueble.valor()*porcentaje/100
}

class Alquiler{
	var meses
	constructor(_meses){
		meses = _meses
	}
	method comision(inmueble) = meses*inmueble.valor()/50000
}

class Operacion{
	var inmueble
	var senialador = null
	constructor(_inmueble){
		inmueble = _inmueble
	}
	method estaSeniado() = senialador != null
	method seniar(_senialador) {senialador = _senialador}
	method comision() = inmueble.comision()
	method concretarOperacion() {
		if (self.estaSeniado()) {
			senialador = null
		}
	}
}

class Persona{
	var nombre
	constructor(_nombre){
		nombre = _nombre
	}
	method nombre() = nombre
}

class Vendedor inherits Persona{
	var historialOperaciones = []
	method realizarOperacion(operacion) = historialOperaciones.add(operacion)
	method concretarOperacion(operacion) {operacion.concretarOperacion()}
	method totalComisiones() = historialOperaciones.sum({operacion=>operacion.comision()})
	method totalReservas() = historialOperaciones.sum({operacion=>operacion.estaSeniada()})
	method totalCerradas() = historialOperaciones.sum({operacion=>!(operacion.estaSeniada())})
	method zonasOperaciones() = historialOperaciones.forEach({registro=>registro.zona()})
	method hayZonasEnComun(vendedor) = self.zonasOperaciones().any({zona=>vendedor.zonasOperaciones().contains(zona)})
	method reservasPisoteadas(vendedor) = historialOperaciones.contains({vendedor.operaciones().any()})
	method operaciones() = historialOperaciones
}

object inmobiliaria{
	var vendedores = []
	method agregarVendedor(vendedor) = vendedores.add(vendedor)
	method mejorVendedorSegun(criterio) = criterio.mejorVendedor(vendedores)
}

object criterioComisiones{
	method mejorVendedor(vendedores) = vendedores.max{vendedor=>vendedor.totalComisiones()}
}

object criterioReservas{
	method mejorVendedor(vendedores) = vendedores.max{vendedor=>vendedor.totalReservas()}
}

object criterioCerradas{
	method mejorVendedor(vendedores) = vendedores.max{vendedor=>vendedor.totalCerradas()}
}