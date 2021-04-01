program AgregarDatosArchivo;
type
    registro=record
        nombre:string;
        salario:real;
    end;
    
    Empleados = file of registro;

{----------------------------------------------------------------------------}

procedure leer(var E:registro);
begin
    write('Nombre: ');
    readln(E.nombre);
    if (E.nombre <> '') then begin
        write('Salario: ');
        readln(E.salario);
    end;
end;
{----------------------------------------------------------------------------}

procedure agregarDato (Var Emp: Empleados); 
var 
    E:registro;
begin
    reset(Emp); 
    seek(Emp,filesize(Emp)); 
    leer(E); 
    while (E.nombre <> '') do begin
        write(Emp,E);     
        leer(E); 
    end;
    close(Emp);
  end;

{----------------------------------------------------------------------------}

var
    Emp:Empleados;
begin
    assign(Emp,'miarchivo.data'); //RUTA RELATIVA
    // assign(Emp,'C:\Users\Cath\Desktop\miarchivo.data'); RUTA ABSOLUTA
    rewrite(Emp);
    agregarDato(Emp);
end.
