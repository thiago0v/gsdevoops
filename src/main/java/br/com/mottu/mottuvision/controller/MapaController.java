package br.com.mottu.mottuvision.controller;

import br.com.mottu.mottuvision.entity.Filial;
import br.com.mottu.mottuvision.entity.Moto;
import br.com.mottu.mottuvision.entity.Usuario;
import br.com.mottu.mottuvision.repository.UsuarioRepository;
import br.com.mottu.mottuvision.service.MotoService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class MapaController {
    private final UsuarioRepository usuarioRepository;
    private final MotoService motoService;

    public MapaController(UsuarioRepository usuarioRepository, MotoService motoService) {
        this.usuarioRepository = usuarioRepository;
        this.motoService = motoService;
    }

    @GetMapping("/mapa")
    public String mapa(Authentication authentication, Model model) {
        Usuario usuario = usuarioRepository.findByEmail(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));

        Filial filial = usuario.getFilial();
        List<Moto> motos = motoService.listarPorFilial(filial);

        model.addAttribute("filial", filial);
        model.addAttribute("motos", motos);
        model.addAttribute("gridSize", 8);
        return "mapa";
    }
}
