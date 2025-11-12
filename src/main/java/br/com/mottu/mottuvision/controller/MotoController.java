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
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class MotoController {
    private final UsuarioRepository usuarioRepository;
    private final MotoService motoService;

    public MotoController(UsuarioRepository usuarioRepository, MotoService motoService) {
        this.usuarioRepository = usuarioRepository;
        this.motoService = motoService;
    }

    @GetMapping("/motos")
    public String listarMotos(Authentication authentication, Model model) {
        Usuario usuario = usuarioRepository.findByEmail(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));

        Filial filial = usuario.getFilial();
        List<Moto> motos = motoService.listarPorFilial(filial);

        model.addAttribute("motos", motos);
        model.addAttribute("filial", filial);
        return "motos";
    }

    @GetMapping("/motos/<built-in function id>")
    public String detalhesMoto(@PathVariable Long id, Authentication authentication, Model model) {
        Usuario usuario = usuarioRepository.findByEmail(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));

        Filial filial = usuario.getFilial();

        Moto moto = motoService.listarPorFilial(filial).stream()
                .filter(m -> m.getId().equals(id))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Moto não encontrada"));

        model.addAttribute("moto", moto);
        model.addAttribute("filial", filial);
        return "moto-detalhe";
    }
}
