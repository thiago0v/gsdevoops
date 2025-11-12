package br.com.mottu.mottuvision;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class MottuvisionApplication {
    public static void main(String[] args) {
        SpringApplication.run(MottuvisionApplication.class, args);
    }
}
