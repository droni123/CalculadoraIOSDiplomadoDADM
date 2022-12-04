//
//  ViewController.swift
//  Calculadora
//
//  Created by De la Cruz Hernández on 30/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnCero: UIButton!
    @IBOutlet weak var btnUno: UIButton!
    @IBOutlet weak var btnDos: UIButton!
    @IBOutlet weak var btnTres: UIButton!
    @IBOutlet weak var btnCuatro: UIButton!
    @IBOutlet weak var btnCinco: UIButton!
    @IBOutlet weak var btnSeis: UIButton!
    @IBOutlet weak var btnSiete: UIButton!
    @IBOutlet weak var btnOcho: UIButton!
    @IBOutlet weak var btnNueve: UIButton!
    
    @IBOutlet weak var btnMultiplicar: UIButton!
    @IBOutlet weak var btnDividir: UIButton!
    @IBOutlet weak var btnRestar: UIButton!
    @IBOutlet weak var btnSumar: UIButton!
    
    @IBOutlet weak var btnPunto: UIButton!
    @IBOutlet weak var btnBorrar: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnIgual: UIButton!
    
    @IBOutlet weak var LabelSuperior: UILabel!
    @IBOutlet weak var LabelInferior: UILabel!
    @IBOutlet weak var visorStak: UIStackView!
    
    let signoMultiplicacion: String = "*"
    let signoDivicion: String = "/"
    let signoResta: String = "-"
    let signoSuma: String = "+"
    
    let signoPunto: String = "."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Estilos de redondeado
        visorStak.round()

        btnCero.round()
        btnUno.round()
        btnDos.round()
        btnTres.round()
        btnCuatro.round()
        btnCinco.round()
        btnSeis.round()
        btnSiete.round()
        btnOcho.round()
        btnNueve.round()
        
        btnPunto.round()
        btnIgual.round(isalto: true)
        btnBorrar.round()
        btnReset.round()
        
        btnSumar.round()
        btnRestar.round()
        btnMultiplicar.round()
        btnDividir.round()
        
        LabelSuperior.numberOfLines = 3
    }
    //Al precionar numeros
    @IBAction func AccionNumeros(_ sender: UIButton) { //ok
        sender.shine()
        let valor = String((sender.titleLabel?.text)!)
        LabelSuperior.text = (LabelSuperior.text ?? "") + valor
        intResolver()
    }
    //Al precionar btn (+ - * /)
    @IBAction func AccionOperaciones(_ sender: UIButton) { //ok
        sender.shine()
        let valor = String((sender.titleLabel?.text)!)
        let textoLabel = (LabelSuperior.text ?? "")
        if(textoLabel != ""){
            let lastCharacter  = String(textoLabel.suffix(1))
            let elements = [signoSuma,signoResta,signoDivicion,signoMultiplicacion]
            if !elements.contains(lastCharacter) {
                LabelSuperior.text = (LabelSuperior.text ?? "") + valor
                intResolver()
            }else if(valor == signoResta){
                let elements2 = [signoResta]
                if !elements2.contains(lastCharacter) {
                    LabelSuperior.text = (LabelSuperior.text ?? "") + valor
                    intResolver()
                }
            }
        }else if(valor == signoResta){
            LabelSuperior.text = (LabelSuperior.text ?? "") + valor
            intResolver()
        }
    }
    //al precionar (.)
    @IBAction func AccionPunto(_ sender: UIButton) { //ok
        sender.shine()
        let valor = String((sender.titleLabel?.text)!)
        let textoLabel = (LabelSuperior.text ?? "")
        do {
            let regExPunto = "([0-9.]+)$" //Regex ULTIMO NIMERO DIGITADO
            //SE EJECUTA EL REGEX
            let regex = try NSRegularExpression(pattern: regExPunto, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: textoLabel, options: [], range: NSRange(location: 0, length: textoLabel.utf8.count))
            //SI SE ENCUENTAN COINCIDENCIAS (MATCH)
            if let match = matches.first {
                ///DATO DE OPERACION ORIGINAL (STRING)
                let original = match.range(at:0)
                if let originalR = Range(original, in: textoLabel) {
                    let numero = String(textoLabel[originalR])
                    let caracterPunto :  Character = Character(signoPunto)
                    if !numero.contains(caracterPunto){ //SI EL ULTIMO DIGITO NO TIENE PUNTO
                        LabelSuperior.text = (LabelSuperior.text ?? "") + valor
                        intResolver()
                    }
                }
            }
        } catch {
        }
    }
    //Al precionar <- borrar
    @IBAction func AccionBorrar(_ sender: UIButton) { //ok
        sender.shine()
        let valorActual = (LabelSuperior.text ?? "")
        LabelSuperior.text = String(valorActual.dropLast())
        //botones borrar
        intResolver()
    }
    //Al precionar reset
    @IBAction func AccionReset(_ sender: UIButton) { //ok
        sender.shine()
        LabelSuperior.text = ""
        LabelInferior.text = ""
        //botones reset
        intResolver()
    }
    //Al precionar igual
    @IBAction func AccionIgual(_ sender: UIButton) { //ok
        sender.shine()
        intResolver(presionaIgual: true)
    }
    
    
    //Funcion que resuvelve las operaciones
    @discardableResult
    func intOperaciones(resultado: inout String,mensaje: inout String,OperacionARealizar:String="+")->String{
        do {
            //Regex Digitos precesidos o no por un signo ( * / - +) puede ser negativo (-)
            let regExpDigito = "((?:(?<=\\\(signoSuma)|\\\(signoResta)|\\\(signoMultiplicacion)|\\\(signoDivicion))-|^-)?[0-9.]+)"

            let regExpMulti = "\(regExpDigito)\\\(signoMultiplicacion)((?:(?<=\\\(signoMultiplicacion))-)?[0-9.]+)" //Regex MULTIPLICACIONES
            let regExpDivic = "\(regExpDigito)\\\(signoDivicion)((?:(?<=\\\(signoDivicion))-)?[0-9.]+)" //Regex DIVICIONES
            let regExpResta = "\(regExpDigito)\\\(signoResta)((?:(?<=\\\(signoResta))-)?[0-9.]+)" //Regex RESTAS
            let regExpSumas = "\(regExpDigito)\\\(signoSuma)((?:(?<=\\\(signoSuma))-)?[0-9.]+)" //Regex SUMAS
            var patternAEjecutar:String = regExpSumas
            //SE SELECCIONA EL REGEX
            switch OperacionARealizar {
                case signoMultiplicacion:
                    patternAEjecutar = regExpMulti
                case signoDivicion:
                    patternAEjecutar = regExpDivic
                case signoResta:
                    patternAEjecutar = regExpResta
                case signoSuma:
                    patternAEjecutar = regExpSumas
                default:
                    patternAEjecutar = regExpSumas
            }
            //SE EJECUTA EL REGEX
            let regex = try NSRegularExpression(pattern: patternAEjecutar, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: resultado, options: [], range: NSRange(location: 0, length: resultado.utf8.count))
            //SI SE ENCUENTAN COINCIDENCIAS (MATCH)
            if let match = matches.first {
                ///DATO DE OPERACION ORIGINAL (STRING) -- SE ALMACENA PARA REMPLAZAR
                var operacion:String = "0\(OperacionARealizar)0"
                let original = match.range(at:0)
                if let originalR = Range(original, in: resultado) {
                    operacion = String(resultado[originalR])
                }
                ///SE EXTRAE NUMERO 1
                var n1:Double = 0
                let original1 = match.range(at:1)
                if let original1R = Range(original1, in: resultado) {
                    n1 = Double(resultado[original1R])!
                }
                ///SE EXTRAE NUMERO 2
                var n2:Double = 0
                let original2 = match.range(at:2)
                if let original2R = Range(original2, in: resultado) {
                    n2 = Double(resultado[original2R])!
                }
                //SE REALIZA LA OPERACION
                switch OperacionARealizar {
                    case signoMultiplicacion: //MULTIPLICACION
                        let res:String = String(n1 * n2)
                        resultado = resultado.replacingOccurrences(of: operacion, with: res, options: .literal, range: nil)
                        intOperaciones(resultado: &resultado,mensaje:&mensaje,OperacionARealizar:OperacionARealizar)
                    case signoDivicion: //DIVICION
                        if(n2 != 0){
                            let res:String = String(n1 / n2)
                            resultado = resultado.replacingOccurrences(of: operacion, with: res, options: .literal, range: nil)
                            intOperaciones(resultado: &resultado,mensaje:&mensaje,OperacionARealizar:OperacionARealizar)
                        }else{
                            mensaje = "¡Divición entre 0!"
                        }
                    case signoResta: //RESTA
                        let res:String = String(n1 - n2)
                        resultado = resultado.replacingOccurrences(of: operacion, with: res, options: .literal, range: nil)
                        intOperaciones(resultado: &resultado,mensaje:&mensaje,OperacionARealizar:OperacionARealizar)
                    case signoSuma: //SUMA
                        let res:String = String(n1 + n2)
                        resultado = resultado.replacingOccurrences(of: operacion, with: res, options: .literal, range: nil)
                        intOperaciones(resultado: &resultado,mensaje:&mensaje,OperacionARealizar:OperacionARealizar)
                    default: //SUMA DEFAULT
                        let res:String = String(n1 + n2)
                        resultado = resultado.replacingOccurrences(of: operacion, with: res, options: .literal, range: nil)
                        intOperaciones(resultado: &resultado,mensaje:&mensaje,OperacionARealizar:OperacionARealizar)
                }
            }
        } catch {
            //print("Unexpected error: \(error).")
            mensaje = "!Regex Malo!"
        }
        return resultado
    }
    @discardableResult
    func intResultado(resultado: inout String,mensaje: inout String)->String{
        let res:String = resultado
        resultado = ""
        do {
            let regExpResultadoValido = "^((?:-)?[0-9.]+)$" //Regex ES UN VALOR VALIDO PARA MOSTRAR (NUMERO CON O SIN DECIMALES)
            let regex = try NSRegularExpression(pattern: regExpResultadoValido, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: res, options: [], range: NSRange(location: 0, length: res.utf8.count))
            if let match = matches.first {
                ///SE VALIDA DATO
                let original = match.range(at:0)
                if let originalR = Range(original, in: res) {
                    var n1:Double = 0
                    n1 = Double(res[originalR])!
                    //ELIMINO CEROS INECESARIOS
                    resultado = n1.removerCerosDelFinal()
                }
            }
        } catch {
            //print("Unexpected error: \(error).")
            mensaje = "!Regex Malo!"
        }
        return resultado
    }
    
    func intResolver(presionaIgual:Bool = false){
        var resultado = (LabelSuperior.text ?? "") //SE OBTIENE LA CADENA ORIGINAL //DE CONTENEDOR
        //RESOLVEMOS OPERACIONES TENIENDO EN CUENTA LA PRIORIDAD DE OPERADORES
        //MULTIPLICACIONES -> DIVICIONES -> RESTAS -> SUMAS
        var mensaje = ""
        intOperaciones(resultado: &resultado,mensaje: &mensaje,OperacionARealizar:signoMultiplicacion) //EJECUTAMOS TODAS LA MULTIPLICACIONES
        intOperaciones(resultado: &resultado,mensaje: &mensaje,OperacionARealizar:signoDivicion) //EJECUTAMOS TODAS LAS DIVICIONES
        intOperaciones(resultado: &resultado,mensaje: &mensaje,OperacionARealizar:signoResta) // EJECUTAMOS TODAS LAS RESTAS
        intOperaciones(resultado: &resultado,mensaje: &mensaje,OperacionARealizar:signoSuma) // EJECUTAMOS TODAS LA SUMAS
        intResultado(resultado: &resultado,mensaje: &mensaje) //VALIDAMOS QUE EL RESULTADO SEA VALIDO PARA IMPRIMIRLO
        if(LabelSuperior.text ?? ""  != resultado){
            LabelInferior.text = resultado //IMPRIMIR EN CONTENEDOR INFERIOR
        }else{
            LabelInferior.text = "" //LIMPIA CONTENEDOR INFERIOR
        }
        if(!mensaje.isEmpty && !presionaIgual){
            LabelInferior.text = mensaje //IMPRIMIR EN CONTENEDOR INFERIOR
        }
        if(presionaIgual){
            LabelSuperior.text = resultado //IMPRIMIR EN CONTENEDOR SUPERIOR
            LabelInferior.text = "" //LIMPIA CONTENEDOR INFERIOR
        }
    }
}
extension Double {
    func removerCerosDelFinal() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 200 //DIGITOS DESPUES DEL DECIMAL
        return String(formatter.string(from: number) ?? "")
    }
}
extension UIStackView {
    func round(isalto : Bool = false) {
        if(isalto){
            layer.cornerRadius = bounds.width / 5
        }else{
            layer.cornerRadius = bounds.height / 5
        }
        clipsToBounds = true
    }
}
extension UIButton {
    func round(isalto : Bool = false) {
        if(isalto){
            layer.cornerRadius = bounds.width / 2
        }else{
            layer.cornerRadius = bounds.height / 2
        }
        clipsToBounds = true
        
        self.layer.shadowColor = UIColor(named: "colorSombra")?.resolvedColor(with: self.traitCollection).cgColor
        self.layer.shadowOffset = CGSizeMake(0.0, 2.5)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
    }
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            }) { (completion) in
                UIView.animate(withDuration: 0.05, animations: {
                    self.alpha = 0.5
                }) { (completion) in
                    UIView.animate(withDuration: 0.05, animations: {
                        self.alpha = 1
                    })
                }
            }
        }
    }
}
