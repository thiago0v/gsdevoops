package br.com.mottu.mottuvision.service;

import br.com.mottu.mottuvision.entity.*;
import br.com.mottu.mottuvision.repository.AlertaRepository;
import br.com.mottu.mottuvision.repository.MotoRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@Transactional
public class AlertaService {
    private final AlertaRepository alertaRepository;
    private final MotoRepository motoRepository;

    public AlertaService(AlertaRepository alertaRepository, MotoRepository motoRepository) {
        this.alertaRepository = alertaRepository;
        this.motoRepository = motoRepository;
    }

    public List<Alerta> ultimosAlertas() {
        return alertaRepository.findTop20ByOrderByDataHoraDesc();
    }

    public List<Alerta> alertasDaMoto(Moto moto) {
        return alertaRepository.findTop10ByMotoOrderByDataHoraDesc(moto);
    }

    public void registrarAlerta(AlertaTipo tipo, String mensagem, Moto moto) {
        alertaRepository.save(new Alerta(tipo, mensagem, moto));
        moto.setStatus(MotoStatus.EM_ALERTA);
    }

    // Regra simples: se uma moto ficar mais de 5 minutos sem atualizar, gera alerta de SEM_SINAL
    @Scheduled(fixedDelay = 60000)
    public void verificarMotosSemSinal() {
        LocalDateTime limite = LocalDateTime.now().minus(5, ChronoUnit.MINUTES);
        motoRepository.findAll().stream()
                .filter(m -> m.getUltimaAtualizacao() != null && m.getUltimaAtualizacao().isBefore(limite))
                .forEach(moto -> {
                    registrarAlerta(AlertaTipo.SEM_SINAL,
                            "Moto sem sinal há mais de 5 minutos",
                            moto);
                });
    }
}
