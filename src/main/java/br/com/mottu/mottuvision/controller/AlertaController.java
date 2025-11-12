package br.com.mottu.mottuvision.controller;

import br.com.mottu.mottuvision.entity.Alerta;
import br.com.mottu.mottuvision.service.AlertaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class AlertaController {
    private final AlertaService alertaService;

    public AlertaController(AlertaService alertaService) {
        this.alertaService = alertaService;
    }

    @GetMapping("/alertas")
    public String listarAlertas(Model model) {
        List<Alerta> alertas = alertaService.ultimosAlertas();
        model.addAttribute("alertas", alertas);
        return "alertas";
    }
}
