package br.com.mottu.mottuvision.repository;

import br.com.mottu.mottuvision.entity.Alerta;
import br.com.mottu.mottuvision.entity.Moto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AlertaRepository extends JpaRepository<Alerta, Long> {
    List<Alerta> findTop10ByMotoOrderByDataHoraDesc(Moto moto);
    List<Alerta> findTop20ByOrderByDataHoraDesc();
}
