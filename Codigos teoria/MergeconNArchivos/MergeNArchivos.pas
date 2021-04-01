program MergeNArchivos;
const
    valoralto='9999';
    dimF=3;
type
    vendedor=record
        cod:string[4];               
        producto:string[10];         
        montoVenta:real;        
    end;
    ventas=record
        cod:string[4];                
        total:real;              
    end;
    maestro = file of ventas; 
    detalle = file of vendedor;  
    arc_detalle=array[1..dimF] of detalle; //vector de archivos detalle
    reg_detalle=array[1..dimF] of vendedor; //vector de registros detalle

var
    min: vendedor;
    VecArchivoDetalle:arc_detalle; //VECTOR ARCHIVO DETALLE
    VecRegistroDetalle:reg_detalle; //VECTOR REGISTRO DETALLE
    mae1:maestro; //ARCHIVO MAESTRO
    regm:ventas; //REGISTRO MAESTRO

{------------------------------------------------------------------------------}

procedure leer (var archivo:detalle; var dato:vendedor);
    begin
      if (not eof(archivo)) then 
            read(archivo,dato)
        else 
            dato.cod:=valoralto;
    end;

{------------------------------------------------------------------------------}

procedure minimo (var VecRegistroDetalle:reg_detalle; var min:vendedor; var VecArchivoDetalle:arc_detalle);
var
    i,minPos:integer;
begin
    min.cod:='9999';
    for i:=1 to dimF do begin
        if (VecRegistroDetalle[i].cod < min.cod) then begin
            min:=VecRegistroDetalle[i];
            minPos:=i;
         end;
    end;
    if (min.cod <> valoralto) then
        Leer(VecArchivoDetalle[minPos],VecRegistroDetalle[minPos]);
end;

{------------------------------------------------------------------------------}
var
    n,i:integer;
    iString:string;
begin
    write('Escriba N: ');
    readln(n);
    for i:= 1 to n do begin
        Str(i,iString); //convierto el valor de i, en un string
        assign (VecArchivoDetalle[i],'detalle'+iString+'.data'); //asigno espacio disco duro
        reset(VecArchivoDetalle[i]); //habilito para lectura
        leer(VecArchivoDetalle[i],VecRegistroDetalle[i]);//guardo la data en mi vector de registros
    end;
    assign (mae1,'maestro.data'); 
    rewrite (mae1); //creo mi maestro
    minimo (VecRegistroDetalle,min,VecArchivoDetalle); //busco el minimo en el detalle
    while (min.cod <> valoralto) do begin //mientras no EOF detalle
        regm.cod:=min.cod; //registro maestro:=codigo minimo
        regm.total:=0; // inicializo contador
        while (regm.cod=min.cod) do begin //mientras el codigo se mantenga
            regm.total:=regm.total+min.montoVenta; //contabilizo mis ventas
            minimo (VecRegistroDetalle,min,VecArchivoDetalle); //busco otro codigo minimo
        end;
        write(mae1,regm); //Actualizo maestro
    end;
    for i:=1 to n do
        close(VecArchivoDetalle[i]); //cierro todos archivos detalle
    close(mae1); //cierro maestro
end.


