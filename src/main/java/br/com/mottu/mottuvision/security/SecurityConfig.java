package br.com.mottu.mottuvision.security;

import br.com.mottu.mottuvision.entity.Usuario;
import br.com.mottu.mottuvision.repository.UsuarioRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public UserDetailsService userDetailsService(UsuarioRepository usuarioRepository) {
        return username -> {
            Usuario usuario = usuarioRepository.findByEmail(username)
                    .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));
            return User.withUsername(usuario.getEmail())
                    .password(usuario.getSenha())
                    .roles(usuario.getRole().name())
                    .build();
        };
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers("/css/**", "/js/**", "/h2-console/**", "/login").permitAll()
                    .requestMatchers("/api/**", "/actuator/**").permitAll()  // API REST pública para demonstração
                    .anyRequest().authenticated()
            )
            .formLogin(login -> login
                    .loginPage("/login").permitAll()
                    .defaultSuccessUrl("/dashboard", true)
            )
            .logout(logout -> logout
                    .logoutSuccessUrl("/login?logout").permitAll()
            );

        http.csrf(csrf -> csrf.ignoringRequestMatchers("/h2-console/**", "/api/**"));  // Desabilitar CSRF para API REST
        http.headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()));

        return http.build();
    }
}
