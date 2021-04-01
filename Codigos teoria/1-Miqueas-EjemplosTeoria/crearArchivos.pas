program crearArchivos;
const 
	cantArchivos = 2;
type
	vendedor = record
        cod: integer;               
        producto: string[10];         
		montoVenta: real;        
    end;
      
    detalle = file of vendedor; 
    arc_detalle=array[1..cantArchivos] of detalle;

procedure leerVendedor(var p:vendedor);
begin
	write('Ingrese codigo de vendedor(4 digitos max): ');
	readln(p.cod);
	if(p.cod <> 0)then begin
		write('Ingrese monto de la venta: ');
		readln(p.montoVenta);
		p.producto := 'PRODUCTO';
	end;
end;

var 
	p:vendedor;
	v_arch_detalle:arc_detalle;
	i:integer;
	icast:String;
begin
	for i := 1 to cantArchivos do begin
		Str(i,icast);
		writeln('Ingrese datos del archivo'+icast+':');
		Assign(v_arch_detalle[i], '/home/sagoh/Escritorio/FOD/EjemplosTeoria/det'+icast);
		rewrite(v_arch_detalle[i]);
		writeln('Ingrese codigos, codigo 0 corta la lectura');
		leerVendedor(p);
		while(p.cod <> 0)do begin
			write(v_arch_detalle[i], p);
			leerVendedor(p);
		end;	
		close(v_arch_detalle[i]);
	end;
	
end.

