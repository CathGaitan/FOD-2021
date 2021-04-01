program ejemploMergeN;
const 
	valoralto = 9999;
	cantArchivos = 2;
type 
	vendedor = record
        cod: integer;               
        producto: string[10];         
		montoVenta: real;        
    end;
    ventas = record
		cod: integer;                
        total: real;              
    end;
    maestro = file of ventas;  
    detalle = file of vendedor; 
    arc_detalle=array[1..cantArchivos] of detalle;
    reg_detalle=array[1..cantArchivos] of vendedor;
  
procedure leer(var archivo:detalle; var dato:vendedor);
begin
    if (not eof( archivo ))then 
		read (archivo, dato)
    else 
		dato.cod := valoralto;
end;


procedure minimo (var reg_det: reg_detalle; var min:vendedor; var deta:arc_detalle);
var 
	i: integer;
	minCod:integer;
	minPos:integer;
begin
      { busco el mínimo elemento del 
        vector reg_det en el campo cod,
        supongamos que es el índice i }
    minPos := 1;
    minCod:=32767;
    for i:= 1 to cantArchivos do begin    	
		if(reg_det[i].cod < minCod)then begin
			min := reg_det[i];
			minCod := reg_det[i].cod;
			minPos := i;
		end;
	end;
	writeln('se determino un minimo');
	leer(deta[minPos], reg_det[minPos]);
	
end;   

  
var 
	min: vendedor;
    deta: arc_detalle;
    reg_det: reg_detalle;
    mae1: maestro;
    regm: ventas;
    i: integer;
    icast : String;
begin
	for i:= 1 to cantArchivos do begin
	    Str(i,icast);
		assign (deta[i], '/home/sagoh/Escritorio/FOD/EjemplosTeoria/det'+icast); 
		reset( deta[i] );
		leer( deta[i], reg_det[i] );
		writeln('se abrio el archivo ', i);
	end;
	assign (mae1, '/home/sagoh/Escritorio/FOD/EjemplosTeoria/maestro'); 
	rewrite (mae1);
	minimo (reg_det, min, deta);
	while (min.cod <> valoralto) do begin
       regm.cod := min.cod;
       regm.total := 0;
       while (regm.cod = min.cod ) do begin
         regm.total := regm.total+ min.montoVenta;
         minimo (reg_det, min, deta);
       end;
       writeln('minimo encontrado ', min.cod);
       write(mae1, regm);
       writeln('se copio el archivo minimo en maestro');
     end;    
	for i:= 1 to cantArchivos do begin
		close(deta[i]);
	end;
	close(mae1);
	reset(mae1);
	while(not eof(mae1))do begin
		read(mae1, regm);
		writeln('codigo: ', regm.cod); 
	end;
	close(mae1);
end.
