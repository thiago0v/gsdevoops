package br.com.mottu.mottuvision.controller;

import br.com.mottu.mottuvision.entity.Filial;
import br.com.mottu.mottuvision.entity.Usuario;
import br.com.mottu.mottuvision.repository.FilialRepository;
import br.com.mottu.mottuvision.repository.UsuarioRepository;
import br.com.mottu.mottuvision.service.MotoService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {
    private final UsuarioRepository usuarioRepository;
    private final MotoService motoService;

    public DashboardController(UsuarioRepository usuarioRepository,
                               MotoService motoService) {
        this.usuarioRepository = usuarioRepository;
        this.motoService = motoService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        Usuario usuario = usuarioRepository.findByEmail(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));

        Filial filial = usuario.getFilial();

        long totalMotos = motoService.contarPorFilial(filial);
        long motosEmAlerta = motoService.contarEmAlertaPorFilial(filial);

        model.addAttribute("usuario", usuario);
        model.addAttribute("filial", filial);
        model.addAttribute("totalMotos", totalMotos);
        model.addAttribute("motosEmAlerta", motosEmAlerta);

        return "dashboard";
    }
}
