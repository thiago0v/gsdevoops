package br.com.mottu.mottuvision.service;

import br.com.mottu.mottuvision.entity.Filial;
import br.com.mottu.mottuvision.entity.Moto;
import br.com.mottu.mottuvision.entity.MotoStatus;
import br.com.mottu.mottuvision.repository.MotoRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class MotoService {
    private final MotoRepository motoRepository;

    public MotoService(MotoRepository motoRepository) {
        this.motoRepository = motoRepository;
    }

    public List<Moto> listarPorFilial(Filial filial) {
        return motoRepository.findByFilial(filial);
    }

    public long contarPorFilial(Filial filial) {
        return motoRepository.findByFilial(filial).size();
    }

    public long contarEmAlertaPorFilial(Filial filial) {
        return motoRepository.findByFilial(filial).stream()
                .filter(m -> m.getStatus() == MotoStatus.EM_ALERTA)
                .count();
    }

    public void atualizarPosicao(String placa, int x, int y) {
        Moto moto = motoRepository.findByPlaca(placa)
                .orElseThrow(() -> new IllegalArgumentException("Moto não encontrada: " + placa));
        moto.setPosicaoX(x);
        moto.setPosicaoY(y);
        moto.setUltimaAtualizacao(LocalDateTime.now());
        moto.setStatus(MotoStatus.OK);
    }
}
