package br.com.mottu.mottuvision;

import br.com.mottu.mottuvision.entity.*;
import br.com.mottu.mottuvision.repository.FilialRepository;
import br.com.mottu.mottuvision.repository.MotoRepository;
import br.com.mottu.mottuvision.repository.UsuarioRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataLoader {
    @Bean
    CommandLineRunner initDatabase(FilialRepository filialRepository,
                                   MotoRepository motoRepository,
                                   UsuarioRepository usuarioRepository,
                                   PasswordEncoder passwordEncoder) {
        return args -> {
            if (filialRepository.count() == 0) {
                Filial sp = new Filial("Filial SP - Centro", "São Paulo", "Brasil");
                Filial rj = new Filial("Filial RJ - Zona Norte", "Rio de Janeiro", "Brasil");
                filialRepository.save(sp);
                filialRepository.save(rj);

                Moto m1 = new Moto("ABC1D23", "Honda CG 160", sp);
                m1.setPosicaoX(2);
                m1.setPosicaoY(3);
                Moto m2 = new Moto("EFG4H56", "Yamaha Fazer 250", sp);
                m2.setPosicaoX(5);
                m2.setPosicaoY(1);
                Moto m3 = new Moto("IJK7L89", "Honda Biz 125", rj);
                m3.setPosicaoX(1);
                m3.setPosicaoY(4);

                motoRepository.save(m1);
                motoRepository.save(m2);
                motoRepository.save(m3);

                Usuario admin = new Usuario("admin@mottu.com",
                        passwordEncoder.encode("123456"),
                        UsuarioRole.ADMIN,
                        sp);

                Usuario opSp = new Usuario("operador.sp@mottu.com",
                        passwordEncoder.encode("123456"),
                        UsuarioRole.OPERADOR,
                        sp);

                Usuario opRj = new Usuario("operador.rj@mottu.com",
                        passwordEncoder.encode("123456"),
                        UsuarioRole.OPERADOR,
                        rj);

                usuarioRepository.save(admin);
                usuarioRepository.save(opSp);
                usuarioRepository.save(opRj);
            }
        };
    }
}
